import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart' hide Task;
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/file_source.dart';
import '../../domain/entities/selected_file.dart';
import '../../domain/failures/failures.dart';
import '../../domain/repositories/i_file_picker_repository.dart';

@LazySingleton(as: IFilePickerRepository)
class FilePickerRepository implements IFilePickerRepository {
  final _imagePicker = ImagePicker();

  @override
  Future<Either<Failure, SelectedFile?>> pickFile(FileSource source) async {
    try {
      return switch (source) {
        FileSource.gallery => _pickImage(ImageSource.gallery),
        FileSource.camera => _pickImage(ImageSource.camera),
        FileSource.pdf => _pickPdf(),
      };
    } catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, SelectedFile?>> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      maxWidth: 2048,
      maxHeight: 2048,
    );
    if (image == null) return right(null);
    final bytes = await image.readAsBytes();
    return right(SelectedFile(path: image.path, name: image.name, size: bytes.length));
  }

  Future<Either<Failure, SelectedFile?>> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null || result.files.isEmpty) return right(null);
    final file = result.files.first;
    if (file.path == null) return right(null);
    return right(SelectedFile(path: file.path!, name: file.name, size: file.size));
  }
}
