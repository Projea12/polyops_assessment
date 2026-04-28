import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';

import '../../entities/file_source.dart';
import '../../entities/selected_file.dart';
import '../../failures/failures.dart';
import '../../repositories/i_file_picker_repository.dart';

@lazySingleton
class PickDocumentFileUseCase {
  final IFilePickerRepository _repository;
  PickDocumentFileUseCase(this._repository);

  Future<Either<Failure, SelectedFile?>> call(FileSource source) =>
      _repository.pickFile(source);
}
