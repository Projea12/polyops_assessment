import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entities/board_task.dart';
import '../../../../domain/entities/task_status.dart';

part 'board_state.freezed.dart';

@freezed
sealed class BoardState with _$BoardState {
  const factory BoardState.initial() = BoardInitial;
  const factory BoardState.loading() = BoardLoading;

  const factory BoardState.loaded({
    required Map<TaskStatus, List<BoardTask>> columns,
    String? draggingTaskId,
    TaskStatus? dragOverColumn,
  }) = BoardLoaded;

  const factory BoardState.error(String message) = BoardError;
}

extension BoardLoadedX on BoardLoaded {
  List<BoardTask> tasksFor(TaskStatus status) => columns[status] ?? [];
  bool get hasDraggingTask => draggingTaskId != null;
}
