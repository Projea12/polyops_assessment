import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';
import 'package:polyops_assessment/domain/failure/failures.dart';

import '../../entities/task.dart';
import '../../entities/task_priority.dart';
import '../../repositories/i_task_repository.dart';

@lazySingleton
class CreateTaskUseCase {
  final ITaskRepository _repository;

  const CreateTaskUseCase(this._repository);

  Future<Either<Failure, Task>> call({
    required String title,
    required String description,
    String? richDescription,
    required TaskPriority priority,
    DateTime? dueDate,
  }) {
    if (title.trim().isEmpty) {
      return Future.value(left(const ValidationFailure('Title cannot be empty')));
    }
    if (title.trim().length > 200) {
      return Future.value(left(const ValidationFailure('Title cannot exceed 200 characters')));
    }

    return _repository.createTask(
      title: title.trim(),
      description: description.trim(),
      richDescription: richDescription,
      priority: priority.name,
      dueDate: dueDate,
    );
  }
}
