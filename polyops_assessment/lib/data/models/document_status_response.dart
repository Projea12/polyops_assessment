class DocumentStatusResponse {
  final String id;
  final String status;
  final double progress;
  final DateTime? verifiedAt;
  final String? rejectionReason;
  final DateTime? expiresAt;

  const DocumentStatusResponse({
    required this.id,
    required this.status,
    required this.progress,
    this.verifiedAt,
    this.rejectionReason,
    this.expiresAt,
  });

  factory DocumentStatusResponse.fromJson(Map<String, dynamic> json) =>
      DocumentStatusResponse(
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'progress': progress,
        if (verifiedAt != null) 'verifiedAt': verifiedAt!.toIso8601String(),
        if (rejectionReason != null) 'rejectionReason': rejectionReason,
        if (expiresAt != null) 'expiresAt': expiresAt!.toIso8601String(),
      };
}
