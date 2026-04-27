import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';

import '../../entities/document_type.dart';
import '../../entities/verification_document.dart';
import '../../failures/failures.dart';
import '../../repositories/i_document_repository.dart';

@injectable
class UploadDocumentUseCase {
  final IDocumentRepository _repository;
  UploadDocumentUseCase(this._repository);

  Future<Either<Failure, VerificationDocument>> call({
    required String filePath,
    required DocumentType type,
  }) =>
      _repository.uploadDocument(filePath: filePath, type: type);
}
