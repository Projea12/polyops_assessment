class DocumentUploadResponse {
  final String id;
  final String status;
  final DateTime uploadedAt;
  final int estimatedProcessingTime;

  const DocumentUploadResponse({
    required this.id,
    required this.status,
    required this.uploadedAt,
    required this.estimatedProcessingTime,
  });

  factory DocumentUploadResponse.fromJson(Map<String, dynamic> json) =>
      DocumentUploadResponse(
        id: json['id'] as String,
        status: json['status'] as String,
        uploadedAt: DateTime.parse(json['uploadedAt'] as String),
        estimatedProcessingTime: json['estimatedProcessingTime'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'uploadedAt': uploadedAt.toIso8601String(),
        'estimatedProcessingTime': estimatedProcessingTime,
      };
}
