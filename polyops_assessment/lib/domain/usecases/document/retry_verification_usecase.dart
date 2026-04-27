import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';
import 'package:polyops_assessment/domain/failure/failures.dart';

import '../../entities/verification_document.dart';
import '../../repositories/i_document_repository.dart';

@injectable
class RetryVerificationUseCase {
  final IDocumentRepository _repository;
  RetryVerificationUseCase(this._repository);

  Future<Either<Failure, VerificationDocument>> call(String id) =>
      _repository.retryVerification(id);
}
