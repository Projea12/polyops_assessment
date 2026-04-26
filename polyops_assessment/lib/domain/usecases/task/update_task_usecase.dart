import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';
import 'package:polyops_assessment/domain/failure/failures.dart';

import '../../entities/task.dart';
import '../../repositories/i_task_repository.dart';

@lazySingleton
class UpdateTaskUseCase {
  final ITaskRepository _repository;

  const UpdateTaskUseCase(this._repository);

  Future<Either<Failure, Task>> call(Task task) {
    if (task.title.trim().isEmpty) {
      return Future.value(left(const ValidationFailure('Title cannot be empty')));
    }
    return _repository.updateTask(task);
  }
}
