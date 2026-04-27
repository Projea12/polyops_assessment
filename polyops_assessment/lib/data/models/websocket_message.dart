class WebSocketMessage {
  final String type;
  final String documentId;
  final String status;
  final double progress;
  final WebSocketDetails details;

  const WebSocketMessage({
    required this.type,
    required this.documentId,
    required this.status,
    required this.progress,
    required this.details,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) =>
      WebSocketMessage(
        type: json['type'] as String,
        documentId: json['documentId'] as String,
        status: json['status'] as String,
        progress: (json['progress'] as num).toDouble(),
        details: WebSocketDetails.fromJson(
            json['details'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'documentId': documentId,
        'status': status,
        'progress': progress,
        'details': details.toJson(),
      };
}

class WebSocketDetails {
  final String stage;
  final double confidence;
  final List<String> issues;

  const WebSocketDetails({
    required this.stage,
    required this.confidence,
    required this.issues,
  });

  factory WebSocketDetails.fromJson(Map<String, dynamic> json) =>
      WebSocketDetails(
        stage: json['stage'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        issues: (json['issues'] as List<dynamic>).cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        'stage': stage,
        'confidence': confidence,
        'issues': issues,
      };
}
