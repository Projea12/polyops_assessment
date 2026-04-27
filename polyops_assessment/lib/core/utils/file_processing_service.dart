import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum FileFormat { jpg, png, pdf, unsupported }

class ProcessedFile {
  final String path;
  final String originalName;
  final int fileSize;
  final String checksum;
  final FileFormat format;

  const ProcessedFile({
    required this.path,
    required this.originalName,
    required this.fileSize,
    required this.checksum,
    required this.format,
  });
}

class FileValidationException implements Exception {
  final String message;
  const FileValidationException(this.message);

  @override
  String toString() => 'FileValidationException: $message';
}

@lazySingleton
class FileProcessingService {
  static const _maxFileSizeBytes = 10 * 1024 * 1024; // 10 MB

  // Downsample target for pixel analysis — fast enough on any device,
  // still large enough for reliable blur / brightness / edge readings.
  static const _analysisSize = 200;

  // Brightness: 0–255 luminance scale.
  // < 40  → too dark to read document text.
  // > 235 → blown-out / overexposed, detail lost.
  static const _minBrightness = 40.0;
  static const _maxBrightness = 235.0;

  // Blur: Laplacian variance on the _analysisSize grid.
  // Sharp documents score 150–2000+; blurry ones score < 80.
  // 80 is conservative — rejects clearly blurry shots without penalising
  // softened edges that still carry readable text.
  static const _minLaplacianVariance = 80.0;

  // Document presence: fraction of interior pixels with a strong Laplacian
  // response (|L| > 15). A blank wall or plain background scores ≈ 0–0.5 %.
  // An actual KYC document (text, borders, photo) scores 3–20 %.
  // 1.5 % is a conservative floor that filters empty frames.
  static const _minEdgeDensity = 0.015;

  /// Validates, compresses (images only), runs quality analysis, and computes
  /// checksum. Throws [FileValidationException] on any failure.
  Future<ProcessedFile> process(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw const FileValidationException('File does not exist');
    }

    final format = _detectFormat(filePath);
    if (format == FileFormat.unsupported) {
      throw const FileValidationException(
          'Unsupported format. Only JPG, PNG, and PDF are accepted.');
    }

    final originalSize = await file.length();
    if (originalSize > _maxFileSizeBytes) {
      throw const FileValidationException(
          'File exceeds the 10 MB size limit.');
    }

    String processedPath = filePath;

    if (format == FileFormat.jpg || format == FileFormat.png) {
      processedPath = await _compressImage(filePath, format);
      await _validateImageQuality(processedPath);
    }

    final processedFile = File(processedPath);
    final bytes = await processedFile.readAsBytes();
    final checksum = _computeChecksum(bytes);

    return ProcessedFile(
      path: processedPath,
      originalName: p.basename(filePath),
      fileSize: bytes.length,
      checksum: checksum,
      format: format,
    );
  }

  FileFormat _detectFormat(String filePath) {
    final ext = p.extension(filePath).toLowerCase();
    return switch (ext) {
      '.jpg' || '.jpeg' => FileFormat.jpg,
      '.png' => FileFormat.png,
      '.pdf' => FileFormat.pdf,
      _ => FileFormat.unsupported,
    };
  }

  Future<String> _compressImage(String filePath, FileFormat format) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(
      dir.path,
      '${p.basenameWithoutExtension(filePath)}_compressed'
      '${format == FileFormat.png ? '.png' : '.jpg'}',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 85,
      format: format == FileFormat.png
          ? CompressFormat.png
          : CompressFormat.jpeg,
      minWidth: 500,
      minHeight: 500,
    );

    if (result == null) {
      throw const FileValidationException('Image compression failed.');
    }

    return result.path;
  }

  Future<void> _validateImageQuality(String filePath) async {
    final file = File(filePath);

    // Cheap pre-flight: a valid compressed image is never this small.
    if (await file.length() < 5 * 1024) {
      throw const FileValidationException(
          'Image quality too low — the document appears blank or corrupt.');
    }

    // Decode to a fixed _analysisSize grid for all pixel-level checks.
    // Using targetWidth/targetHeight keeps this fast regardless of source
    // resolution (a 12 MP camera shot is still only 200×N pixels here).
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: _analysisSize,
      targetHeight: _analysisSize,
    );
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final pixelData =
        await image.toByteData(format: ui.ImageByteFormat.rawRgba);

    if (pixelData == null) {
      throw const FileValidationException(
          'Could not decode image for quality analysis.');
    }

    final w = image.width;
    final h = image.height;
    final totalPixels = w * h;

    // ── Build greyscale plane ─────────────────────────────────────────────────
    // ITU-R BT.601 luma coefficients.
    final gray = Float64List(totalPixels);
    for (var i = 0; i < totalPixels; i++) {
      final r = pixelData.getUint8(i * 4);
      final g = pixelData.getUint8(i * 4 + 1);
      final b = pixelData.getUint8(i * 4 + 2);
      gray[i] = 0.299 * r + 0.587 * g + 0.114 * b;
    }

    // ── Brightness check ─────────────────────────────────────────────────────
    var lumaSum = 0.0;
    for (var i = 0; i < totalPixels; i++) {
      lumaSum += gray[i];
    }
    final avgLuma = lumaSum / totalPixels;

    if (avgLuma < _minBrightness) {
      throw const FileValidationException(
          'Image is too dark — ensure the document is well-lit before capturing.');
    }
    if (avgLuma > _maxBrightness) {
      throw const FileValidationException(
          'Image is overexposed — move away from direct flash or strong backlighting.');
    }

    // ── Blur detection (Laplacian variance) ──────────────────────────────────
    // Apply the 4-neighbour discrete Laplacian over interior pixels only.
    // Variance of the responses is a standard focus measure: high variance
    // means sharp edges, low variance means blur.
    var lapSum = 0.0;
    var lapSumSq = 0.0;
    var edgeCount = 0;
    final interiorPixels = (w - 2) * (h - 2);

    for (var y = 1; y < h - 1; y++) {
      for (var x = 1; x < w - 1; x++) {
        final center = gray[y * w + x];
        final lap = -4.0 * center +
            gray[(y - 1) * w + x] +
            gray[(y + 1) * w + x] +
            gray[y * w + (x - 1)] +
            gray[y * w + (x + 1)];

        lapSum += lap;
        lapSumSq += lap * lap;
        if (lap.abs() > 15) edgeCount++;
      }
    }

    final lapMean = lapSum / interiorPixels;
    final lapVariance = (lapSumSq / interiorPixels) - (lapMean * lapMean);

    if (lapVariance < _minLaplacianVariance) {
      throw const FileValidationException(
          'Image is too blurry — hold the camera steady and ensure the document is in focus.');
    }

    // ── Document presence (edge density) ─────────────────────────────────────
    // A KYC document always has text, borders, and/or a photo — producing
    // many strong Laplacian responses. A blank frame, table surface, or
    // solid-colour background will have almost none.
    final edgeDensity = edgeCount / interiorPixels;

    if (edgeDensity < _minEdgeDensity) {
      throw const FileValidationException(
          'No document detected — ensure the document fills the frame and is clearly visible.');
    }
  }

  String _computeChecksum(Uint8List bytes) {
    final digest = sha256.convert(bytes);
    return base64Encode(digest.bytes);
  }
}
