import 'package:injectable/injectable.dart';

import '../../entities/connectivity_status.dart';
import '../../entities/verification_document.dart';
import '../../repositories/i_document_repository.dart';

@lazySingleton
class WatchDocumentUseCase {
  final IDocumentRepository _repository;
  WatchDocumentUseCase(this._repository);

  Stream<VerificationDocument> call(String id) =>
      _repository.watchDocument(id);

  Stream<List<VerificationDocument>> watchAll() =>
      _repository.watchAllDocuments();

  ConnectivityStatus get connectivityStatus => _repository.connectivityStatus;

  Stream<ConnectivityStatus> watchConnectivityStatus() =>
      _repository.watchConnectivityStatus();
}
