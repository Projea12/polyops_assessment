enum VerificationStatus {
  pending,
  processing,
  verified,
  rejected;

  String get apiValue => switch (this) {
        VerificationStatus.pending => 'PENDING',
        VerificationStatus.processing => 'PROCESSING',
        VerificationStatus.verified => 'VERIFIED',
        VerificationStatus.rejected => 'REJECTED',
      };

  String get label => switch (this) {
        VerificationStatus.pending => 'Pending',
        VerificationStatus.processing => 'Processing',
        VerificationStatus.verified => 'Verified',
        VerificationStatus.rejected => 'Rejected',
      };

  static VerificationStatus fromApi(String value) => switch (value) {
        'PENDING' => VerificationStatus.pending,
        'UPLOADED' => VerificationStatus.pending, // upload response maps to pending
        'PROCESSING' => VerificationStatus.processing,
        'VERIFIED' => VerificationStatus.verified,
        'REJECTED' => VerificationStatus.rejected,
        _ => throw ArgumentError('Unknown verification status: $value'),
      };
}
