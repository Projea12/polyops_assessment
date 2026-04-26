import 'task_priority.dart';
import 'task_status.dart';

class BoardTask {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final int boardPosition;
  final DateTime updatedAt;
  final int commentCount;
  final bool isPending;

  const BoardTask({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.boardPosition,
    required this.updatedAt,
    this.commentCount = 0,
    this.isPending = false,
  });

  BoardTask copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    int? boardPosition,
    DateTime? updatedAt,
    int? commentCount,
    bool? isPending,
  }) {
    return BoardTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      boardPosition: boardPosition ?? this.boardPosition,
      updatedAt: updatedAt ?? this.updatedAt,
      commentCount: commentCount ?? this.commentCount,
      isPending: isPending ?? this.isPending,
    );
  }

  bool get isOverdue =>
      dueDate != null &&
      dueDate!.isBefore(DateTime.now()) &&
      status != TaskStatus.done;

  bool get isDone => status == TaskStatus.done;

  @override
  bool operator ==(Object other) =>
      other is BoardTask && other.id == id && other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(id, updatedAt);
}
