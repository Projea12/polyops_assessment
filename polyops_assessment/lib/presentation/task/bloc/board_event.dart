import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entities/task_status.dart';

part 'board_event.freezed.dart';

@freezed
sealed class BoardEvent with _$BoardEvent {
  const factory BoardEvent.loadBoard() = LoadBoard;

  const factory BoardEvent.moveTask({
    required String taskId,
    required TaskStatus from,
    required TaskStatus to,
    required int newPosition,
  }) = MoveTask;

  const factory BoardEvent.dragStarted({required String taskId}) = DragStarted;
  const factory BoardEvent.dragEnded() = DragEnded;
  const factory BoardEvent.hoverColumn({TaskStatus? status}) = HoverColumn;
}
