import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entities/task_priority.dart';

part 'task_form_event.freezed.dart';

@freezed
sealed class TaskFormEvent with _$TaskFormEvent {
  const factory TaskFormEvent.submitted({
    required String title,
    required String description,
    required String richDescription,
    required TaskPriority priority,
    DateTime? dueDate,
  }) = TaskFormSubmitted;

  const factory TaskFormEvent.priorityChanged(TaskPriority priority) =
      TaskFormPriorityChanged;

  const factory TaskFormEvent.dueDateChanged(DateTime? dueDate) =
      TaskFormDueDateChanged;
}
