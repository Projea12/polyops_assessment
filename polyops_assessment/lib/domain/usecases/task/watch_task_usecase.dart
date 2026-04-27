import 'package:injectable/injectable.dart';

import '../../entities/task.dart';
import '../../repositories/i_task_repository.dart';

@lazySingleton
class WatchTaskUseCase {
  final ITaskRepository _repository;
  WatchTaskUseCase(this._repository);

  Stream<Task> call(String id) => _repository.watchTask(id);
}
