import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';

import '../../failures/failures.dart';
import '../../repositories/i_task_repository.dart';

@lazySingleton
class DeleteTaskUseCase {
  final ITaskRepository _repository;

  const DeleteTaskUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String taskId) {
    if (taskId.trim().isEmpty) {
      return Future.value(left(const ValidationFailure('Task ID cannot be empty')));
    }
    return _repository.deleteTask(taskId);
  }
}
