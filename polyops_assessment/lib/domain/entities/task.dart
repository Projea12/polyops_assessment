import 'task_priority.dart';
import 'task_status.dart';
import 'comment.dart';
import 'activity_entry.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String? richDescription;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;
  final bool isPending;
  final int boardPosition;
  final List<Comment> comments;
  final List<ActivityEntry> activityHistory;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    this.richDescription,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
    this.isPending = false,
    this.boardPosition = 0,
    this.comments = const [],
    this.activityHistory = const [],
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? richDescription,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    bool? isPending,
    int? boardPosition,
    List<Comment>? comments,
    List<ActivityEntry>? activityHistory,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      richDescription: richDescription ?? this.richDescription,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      isPending: isPending ?? this.isPending,
      boardPosition: boardPosition ?? this.boardPosition,
      comments: comments ?? this.comments,
      activityHistory: activityHistory ?? this.activityHistory,
    );
  }

  bool get isOverdue =>
      dueDate != null &&
      dueDate!.isBefore(DateTime.now()) &&
      status != TaskStatus.done;

  @override
  bool operator ==(Object other) =>
      other is Task && other.id == id && other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(id, updatedAt);
}
