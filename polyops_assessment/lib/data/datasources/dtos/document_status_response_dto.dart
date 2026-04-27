

import 'package:polyops_assessment/domain/entities/verification_document.dart';
import 'package:polyops_assessment/domain/entities/verification_status.dart';

class DocumentStatusResponseDto {
  final String id;
  final String status;
  final double progress;
  final DateTime? verifiedAt;
  final String? rejectionReason;
  final DateTime? expiresAt;

  const DocumentStatusResponseDto({
    required this.id,
    required this.status,
    required this.progress,
    this.verifiedAt,
    this.rejectionReason,
    this.expiresAt,
  });

  factory DocumentStatusResponseDto.fromJson(Map<String, dynamic> json) =>
      DocumentStatusResponseDto(
        id: json['id'] as String,
        status: json['status'] as String,
        progress: (json['progress'] as num).toDouble(),
        verifiedAt: json['verifiedAt'] != null
            ? DateTime.parse(json['verifiedAt'] as String)
            : null,
        rejectionReason: json['rejectionReason'] as String?,
        expiresAt: json['expiresAt'] != null
            ? DateTime.parse(json['expiresAt'] as String)
            : null,
      );

  VerificationDocument toDomain(VerificationDocument existing) =>
      existing.copyWith(
        status: VerificationStatus.fromApi(status),
        // Progress must never go backwards — take the maximum of current and incoming
        progress: progress > existing.progress ? progress : existing.progress,
        verifiedAt: verifiedAt,
        expiresAt: expiresAt,
        rejectionReason: rejectionReason,
        isOptimistic: false,
        optimisticSnapshot: null,
      );
}
