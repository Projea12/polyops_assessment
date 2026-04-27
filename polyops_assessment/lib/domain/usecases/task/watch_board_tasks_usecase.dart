import 'package:injectable/injectable.dart';

import '../../entities/board_task.dart';
import '../../entities/task_status.dart';
import '../../repositories/i_task_repository.dart';

@lazySingleton
class WatchBoardTasksByStatusUseCase {
  final ITaskRepository _repository;
  WatchBoardTasksByStatusUseCase(this._repository);

  Stream<List<BoardTask>> call(TaskStatus status) =>
      _repository.watchBoardTasksByStatus(status);
}
