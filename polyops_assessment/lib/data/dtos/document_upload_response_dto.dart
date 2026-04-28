import '../../domain/entities/document_type.dart';
import '../../domain/entities/verification_document.dart';
import '../../domain/entities/verification_status.dart';

class DocumentUploadResponseDto {
  final String id;
  final String status;
  final DateTime uploadedAt;
  final int estimatedProcessingTime;

  const DocumentUploadResponseDto({
    required this.id,
    required this.status,
    required this.uploadedAt,
    required this.estimatedProcessingTime,
  });

  factory DocumentUploadResponseDto.fromJson(Map<String, dynamic> json) =>
      DocumentUploadResponseDto(
        id: json['id'] as String,
        status: json['status'] as String,
        uploadedAt: DateTime.parse(json['uploadedAt'] as String),
        estimatedProcessingTime: json['estimatedProcessingTime'] as int,
      );

  VerificationDocument toDomain({
    required DocumentType type,
    required String filePath,
    required String originalName,
    required int fileSize,
  }) =>
      VerificationDocument(
        id: id,
        type: type,
        status: VerificationStatus.pending,
        progress: 0.0,
        filePath: filePath,
        originalName: originalName,
        fileSize: fileSize,
        uploadedAt: uploadedAt,
        estimatedProcessingTime: estimatedProcessingTime,
        isOptimistic: false,
      );
}
