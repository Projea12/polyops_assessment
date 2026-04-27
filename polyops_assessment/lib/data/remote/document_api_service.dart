import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:polyops_assessment/core/auth/auth_token_provider.dart';
import 'package:polyops_assessment/data/datasources/dtos/document_status_response_dto.dart';
import 'package:polyops_assessment/data/datasources/dtos/document_upload_response_dto.dart';

import '../../../domain/entities/document_type.dart';
import '../../../domain/entities/verification_status.dart';


@lazySingleton
class DocumentApiService {
  final AuthTokenProvider _authTokenProvider;
  final _random = Random();

  DocumentApiService(this._authTokenProvider);

  // Simulates: Authorization: Bearer <token>, Content-Type: multipart/form-data
  Map<String, String> get _headers => {
        'Authorization': _authTokenProvider.bearerHeader,
        'Content-Type': 'multipart/form-data',
      };

  // HEAD /health — lightweight reachability check (5% captive-portal simulation)
  Future<bool> probe() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _random.nextDouble() > 0.05;
  }

  // POST /api/v1/documents/upload
  Future<DocumentUploadResponseDto> uploadDocument({
    required String filePath,
    required DocumentType type,
    required String originalName,
    required int fileSize,
    required String checksum,
  }) async {
    // In production: attach _headers to the multipart HTTP request
    assert(_headers['Authorization'] != null);
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(700)));

    return DocumentUploadResponseDto(
      id: _generateId(),
      status: 'UPLOADED',
      uploadedAt: DateTime.now(),
      estimatedProcessingTime: 20 + _random.nextInt(40),
    );
  }

  // GET /api/v1/documents/{id}/status
  // currentStatus ensures the status only advances forward — never regresses.
  Future<DocumentStatusResponseDto> getStatus(
    String id,
    VerificationStatus currentStatus,
  ) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(200)));

    // Terminal statuses — no further progression
    if (currentStatus == VerificationStatus.verified ||
        currentStatus == VerificationStatus.rejected) {
      return _terminalResponse(id, currentStatus);
    }

    final roll = _random.nextDouble();

    if (currentStatus == VerificationStatus.pending) {
      // Can advance to PROCESSING or stay PENDING
      if (roll < 0.4) {
        return DocumentStatusResponseDto(
            id: id, status: 'PENDING', progress: 0.0);
      }
      return DocumentStatusResponseDto(
          id: id, status: 'PROCESSING', progress: 0.1 + _random.nextDouble() * 0.3);
    }

    // currentStatus == PROCESSING — can advance to VERIFIED/REJECTED or continue
    if (roll < 0.4) {
      return DocumentStatusResponseDto(
          id: id,
          status: 'PROCESSING',
          progress: 0.3 + _random.nextDouble() * 0.5);
    } else if (roll < 0.8) {
      return DocumentStatusResponseDto(
        id: id,
        status: 'VERIFIED',
        progress: 1.0,
        verifiedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 365)),
      );
    } else {
      return DocumentStatusResponseDto(
        id: id,
        status: 'REJECTED',
        progress: 1.0,
        rejectionReason: _randomRejectionReason(),
      );
    }
  }

  DocumentStatusResponseDto _terminalResponse(
      String id, VerificationStatus status) {
    if (status == VerificationStatus.verified) {
      return DocumentStatusResponseDto(
        id: id,
        status: 'VERIFIED',
        progress: 1.0,
        verifiedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 365)),
      );
    }
    return DocumentStatusResponseDto(
      id: id,
      status: 'REJECTED',
      progress: 1.0,
      rejectionReason: _randomRejectionReason(),
    );
  }

  String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(12, (_) => chars[_random.nextInt(chars.length)])
        .join();
  }

  String _randomRejectionReason() {
    const reasons = [
      'Document image is blurry or low quality',
      'Document appears to be expired',
      'Unable to verify document authenticity',
      'Document type does not match the provided category',
      'Face photo is not clearly visible',
    ];
    return reasons[_random.nextInt(reasons.length)];
  }
}
