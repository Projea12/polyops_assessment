import '../../../domain/entities/task.dart';

abstract class TaskDetailEvent {
  const TaskDetailEvent();
}

final class TaskDetailSubscribed extends TaskDetailEvent {
  final String taskId;
  const TaskDetailSubscribed(this.taskId);
}

final class TaskDetailSaveRequested extends TaskDetailEvent {
  final Task task;
  const TaskDetailSaveRequested(this.task);
}

final class TaskDetailDeleteRequested extends TaskDetailEvent {
  final String taskId;
  const TaskDetailDeleteRequested(this.taskId);
}

final class TaskDetailCommentSubmitted extends TaskDetailEvent {
  final String taskId;
  final String content;
  const TaskDetailCommentSubmitted({required this.taskId, required this.content});
}
