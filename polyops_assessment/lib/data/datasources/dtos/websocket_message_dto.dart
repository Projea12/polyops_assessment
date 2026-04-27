

import 'package:polyops_assessment/domain/entities/verification_document.dart';
import 'package:polyops_assessment/domain/entities/verification_stage.dart';
import 'package:polyops_assessment/domain/entities/verification_status.dart';

class WebSocketMessageDto {
  final String type;
  final String documentId;
  final String status;
  final double progress;
  final WebSocketDetailsDto details;

  const WebSocketMessageDto({
    required this.type,
    required this.documentId,
    required this.status,
    required this.progress,
    required this.details,
  });

  factory WebSocketMessageDto.fromJson(Map<String, dynamic> json) =>
      WebSocketMessageDto(
        type: json['type'] as String,
        documentId: json['documentId'] as String,
        status: json['status'] as String,
        progress: (json['progress'] as num).toDouble(),
        details: WebSocketDetailsDto.fromJson(
            json['details'] as Map<String, dynamic>),
      );

  VerificationDocument toDomain(VerificationDocument existing) =>
      existing.copyWith(
        status: VerificationStatus.fromApi(status),
        // Progress must never go backwards
        progress: progress > existing.progress ? progress : existing.progress,
        isOptimistic: false,
        optimisticSnapshot: null,
        currentStage: VerificationStage(
          stage: details.stage,
          confidence: details.confidence,
          issues: details.issues,
        ),
      );
}

class WebSocketDetailsDto {
  final String stage;
  final double confidence;
  final List<String> issues;

  const WebSocketDetailsDto({
    required this.stage,
    required this.confidence,
    required this.issues,
  });

  factory WebSocketDetailsDto.fromJson(Map<String, dynamic> json) =>
      WebSocketDetailsDto(
        stage: json['stage'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        issues: (json['issues'] as List<dynamic>).cast<String>(),
      );
}
