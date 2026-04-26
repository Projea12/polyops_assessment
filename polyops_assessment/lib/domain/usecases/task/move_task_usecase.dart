import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';
import 'package:polyops_assessment/domain/failure/failures.dart';

import '../../entities/task.dart';
import '../../entities/task_status.dart';
import '../../repositories/i_task_repository.dart';

@lazySingleton
class MoveTaskUseCase {
  final ITaskRepository _repository;

  const MoveTaskUseCase(this._repository);

  Future<Either<Failure, Task>> call({
    required String taskId,
    required TaskStatus from,
    required TaskStatus to,
    required int newPosition,
  }) {
    if (from == to) {
      return Future.value(
        left(const ValidationFailure('Source and destination columns are the same')),
      );
    }
    return _repository.moveTask(
      taskId: taskId,
      from: from,
      to: to,
      newPosition: newPosition,
    );
  }
}
