enum ActivityAction {
  taskCreated,
  taskUpdated,
  taskMoved,
  taskDeleted,
  commentAdded,
  commentEdited,
  priorityChanged,
  dueDateSet,
  dueDateCleared,
}

extension ActivityActionExtension on ActivityAction {
  String describe(Map<String, dynamic> metadata) => switch (this) {
        ActivityAction.taskCreated => 'Task created',
        ActivityAction.taskUpdated => 'Task updated',
        ActivityAction.taskMoved =>
          'Moved from ${metadata['from']} to ${metadata['to']}',
        ActivityAction.taskDeleted => 'Task deleted',
        ActivityAction.commentAdded => 'Comment added',
        ActivityAction.commentEdited => 'Comment edited',
        ActivityAction.priorityChanged =>
          'Priority changed to ${metadata['priority']}',
        ActivityAction.dueDateSet => 'Due date set to ${metadata['dueDate']}',
        ActivityAction.dueDateCleared => 'Due date cleared',
      };
}

class ActivityEntry {
  final String id;
  final String taskId;
  final String actorId;
  final String actorName;
  final ActivityAction action;
  final Map<String, dynamic> metadata;
  final DateTime timestamp;

  const ActivityEntry({
    required this.id,
    required this.taskId,
    required this.actorId,
    required this.actorName,
    required this.action,
    required this.metadata,
    required this.timestamp,
  });

  String get description => action.describe(metadata);

  @override
  bool operator ==(Object other) => other is ActivityEntry && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
