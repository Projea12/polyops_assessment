import 'package:fpdart/fpdart.dart' hide Task;

import '../entities/connectivity_status.dart';
import '../entities/document_audit_entry.dart';
import '../entities/document_type.dart';
import '../entities/verification_document.dart';
import '../failures/failures.dart';

abstract class IDocumentRepository {
  Future<Either<Failure, VerificationDocument>> uploadDocument({
    required String filePath,
    required DocumentType type,
  });

  Stream<VerificationDocument> watchDocument(String id);

  Stream<List<VerificationDocument>> watchAllDocuments();

  Future<Either<Failure, VerificationDocument>> getDocumentStatus(String id);

  Future<Either<Failure, VerificationDocument>> retryVerification(String id);

  Future<Either<Failure, List<VerificationDocument>>> getDocumentHistory();

  Stream<List<DocumentAuditEntry>> watchAuditTrail(String documentId);

  ConnectivityStatus get connectivityStatus;

  Stream<ConnectivityStatus> watchConnectivityStatus();
}
