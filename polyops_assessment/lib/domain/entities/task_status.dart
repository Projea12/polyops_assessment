enum TaskStatus { todo, inProgress, done }

extension TaskStatusExtension on TaskStatus {
  String get label => switch (this) {
        TaskStatus.todo => 'To Do',
        TaskStatus.inProgress => 'In Progress',
        TaskStatus.done => 'Done',
      };

  String get columnId => switch (this) {
        TaskStatus.todo => 'todo',
        TaskStatus.inProgress => 'in_progress',
        TaskStatus.done => 'done',
      };
}
