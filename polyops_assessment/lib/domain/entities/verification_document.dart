import 'document_type.dart';
import 'verification_status.dart';
import 'verification_stage.dart';

// Sentinel for nullable copyWith fields — distinguishes "set to null" from "not provided"
class _Absent {
  const _Absent();
}

const _absent = _Absent();

class VerificationDocument {
  final String id;
  final DocumentType type;
  final VerificationStatus status;
  final double progress;
  final String filePath;
  final String originalName;
  final int fileSize;
  final DateTime uploadedAt;
  final DateTime? verifiedAt;
  final DateTime? expiresAt;
  final String? rejectionReason;
  final VerificationStage? currentStage;
  final int estimatedProcessingTime;
  final bool isOptimistic;
  final VerificationDocument? optimisticSnapshot;
  final int retryCount;

  const VerificationDocument({
    required this.id,
    required this.type,
    required this.status,
    required this.progress,
    required this.filePath,
    required this.originalName,
    required this.fileSize,
    required this.uploadedAt,
    this.verifiedAt,
    this.expiresAt,
    this.rejectionReason,
    this.currentStage,
    this.estimatedProcessingTime = 30,
    this.isOptimistic = false,
    this.optimisticSnapshot,
    this.retryCount = 0,
  });

  VerificationDocument copyWith({
    String? id,
    DocumentType? type,
    VerificationStatus? status,
    double? progress,
    String? filePath,
    String? originalName,
    int? fileSize,
    DateTime? uploadedAt,
    // Nullable fields use Object? + sentinel so callers can pass null explicitly
    Object? verifiedAt = _absent,
    Object? expiresAt = _absent,
    Object? rejectionReason = _absent,
    Object? currentStage = _absent,
    int? estimatedProcessingTime,
    bool? isOptimistic,
    Object? optimisticSnapshot = _absent,
    int? retryCount,
  }) {
    return VerificationDocument(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      filePath: filePath ?? this.filePath,
      originalName: originalName ?? this.originalName,
      fileSize: fileSize ?? this.fileSize,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      verifiedAt:
          verifiedAt == _absent ? this.verifiedAt : verifiedAt as DateTime?,
      expiresAt:
          expiresAt == _absent ? this.expiresAt : expiresAt as DateTime?,
      rejectionReason: rejectionReason == _absent
          ? this.rejectionReason
          : rejectionReason as String?,
      currentStage: currentStage == _absent
          ? this.currentStage
          : currentStage as VerificationStage?,
      estimatedProcessingTime:
          estimatedProcessingTime ?? this.estimatedProcessingTime,
      isOptimistic: isOptimistic ?? this.isOptimistic,
      optimisticSnapshot: optimisticSnapshot == _absent
          ? this.optimisticSnapshot
          : optimisticSnapshot as VerificationDocument?,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  /// Returns the pre-optimistic state, or this if no snapshot exists.
  VerificationDocument rollback() => optimisticSnapshot ?? this;

  /// Resets all fields that change across a retry cycle.
  VerificationDocument resetForRetry() => copyWith(
        status: VerificationStatus.pending,
        progress: 0.0,
        rejectionReason: null,
        currentStage: null,
        verifiedAt: null,
        expiresAt: null,
        isOptimistic: true,
        optimisticSnapshot: this,
        retryCount: retryCount + 1,
      );

  bool get isTerminal =>
      status == VerificationStatus.verified ||
      status == VerificationStatus.rejected;

  bool get canRetry =>
      status == VerificationStatus.rejected && retryCount < 3;

  /// Safe after app restart — clamps to 0 once estimatedProcessingTime is exceeded.
  Duration get estimatedTimeRemaining {
    if (isTerminal) return Duration.zero;
    final elapsed = DateTime.now().difference(uploadedAt).inSeconds;
    final remaining = estimatedProcessingTime - elapsed;
    return Duration(seconds: remaining.clamp(0, estimatedProcessingTime));
  }

  @override
  bool operator ==(Object other) =>
      other is VerificationDocument &&
      other.id == id &&
      other.status == status &&
      other.progress == progress;

  @override
  int get hashCode => Object.hash(id, status, progress);
}
