import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entities/task.dart';
import '../../../../domain/entities/task_priority.dart';
import '../../../../domain/entities/task_status.dart';

part 'task_detail_event.freezed.dart';

@freezed
sealed class TaskDetailEvent with _$TaskDetailEvent {
  const factory TaskDetailEvent.subscribed(String taskId) = TaskDetailSubscribed;
  const factory TaskDetailEvent.saveRequested(Task task) = TaskDetailSaveRequested;
  const factory TaskDetailEvent.deleteRequested(String taskId) = TaskDetailDeleteRequested;
  const factory TaskDetailEvent.commentSubmitted({
    required String taskId,
    required String content,
  }) = TaskDetailCommentSubmitted;
  const factory TaskDetailEvent.editEntered() = TaskDetailEditEntered;
  const factory TaskDetailEvent.editCancelled() = TaskDetailEditCancelled;
  const factory TaskDetailEvent.statusChanged(TaskStatus status) = TaskDetailStatusChanged;
  const factory TaskDetailEvent.priorityChanged(TaskPriority priority) = TaskDetailPriorityChanged;
  const factory TaskDetailEvent.dueDateChanged(DateTime? date) = TaskDetailDueDateChanged;
}
