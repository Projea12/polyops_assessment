import '../../../domain/entities/task_priority.dart';

abstract class TaskFormEvent {
  const TaskFormEvent();
}

final class TaskFormSubmitted extends TaskFormEvent {
  final String title;
  final String description;
  final String richDescription;
  final TaskPriority priority;
  final DateTime? dueDate;

  const TaskFormSubmitted({
    required this.title,
    required this.description,
    required this.richDescription,
    required this.priority,
    required this.dueDate,
  });
}
