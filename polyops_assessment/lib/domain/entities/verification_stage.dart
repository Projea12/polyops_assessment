class VerificationStage {
  final String stage;
  final double confidence;
  final List<String> issues;

  const VerificationStage({
    required this.stage,
    required this.confidence,
    this.issues = const [],
  });

  bool get hasIssues => issues.isNotEmpty;

  VerificationStage copyWith({
    String? stage,
    double? confidence,
    List<String>? issues,
  }) {
    return VerificationStage(
      stage: stage ?? this.stage,
      confidence: confidence ?? this.confidence,
      issues: issues ?? this.issues,
    );
  }
}
