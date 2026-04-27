import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';

import '../../entities/verification_document.dart';
import '../../failures/failures.dart';
import '../../repositories/i_document_repository.dart';

@lazySingleton
class GetDocumentHistoryUseCase {
  final IDocumentRepository _repository;
  GetDocumentHistoryUseCase(this._repository);

  Future<Either<Failure, List<VerificationDocument>>> call() =>
      _repository.getDocumentHistory();
}
