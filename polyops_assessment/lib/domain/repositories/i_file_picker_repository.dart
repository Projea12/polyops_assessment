import 'package:fpdart/fpdart.dart' hide Task;

import '../entities/file_source.dart';
import '../entities/selected_file.dart';
import '../failures/failures.dart';

abstract class IFilePickerRepository {
  /// Returns [Right(null)] when the user cancels the picker.
  Future<Either<Failure, SelectedFile?>> pickFile(FileSource source);
}
