import 'package:injectable/injectable.dart';

import '../../entities/document_audit_entry.dart';
import '../../repositories/i_document_repository.dart';

@injectable
class WatchAuditTrailUseCase {
  final IDocumentRepository _repository;
  WatchAuditTrailUseCase(this._repository);

  Stream<List<DocumentAuditEntry>> call(String documentId) =>
      _repository.watchAuditTrail(documentId);
}
