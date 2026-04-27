import 'verification_status.dart';

class DocumentAuditEntry {
  final String id;
  final String documentId;
  final VerificationStatus fromStatus;
  final VerificationStatus toStatus;
  final String? note;
  final DateTime timestamp;

  const DocumentAuditEntry({
    required this.id,
    required this.documentId,
    required this.fromStatus,
    required this.toStatus,
    this.note,
    required this.timestamp,
  });
}
