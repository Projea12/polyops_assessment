enum TaskPriority { low, medium, high, critical }

extension TaskPriorityExtension on TaskPriority {
  String get label => switch (this) {
        TaskPriority.low => 'Low',
        TaskPriority.medium => 'Medium',
        TaskPriority.high => 'High',
        TaskPriority.critical => 'Critical',
      };

  int get sortOrder => switch (this) {
        TaskPriority.low => 0,
        TaskPriority.medium => 1,
        TaskPriority.high => 2,
        TaskPriority.critical => 3,
      };
}
