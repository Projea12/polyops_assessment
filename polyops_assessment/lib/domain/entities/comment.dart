class Comment {
  final String id;
  final String taskId;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;
  final DateTime? editedAt;

  const Comment({
    required this.id,
    required this.taskId,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
    this.editedAt,
  });

  bool get isEdited => editedAt != null;

  Comment copyWith({
    String? content,
    DateTime? editedAt,
  }) {
    return Comment(
      id: id,
      taskId: taskId,
      authorId: authorId,
      authorName: authorName,
      content: content ?? this.content,
      createdAt: createdAt,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  @override
  bool operator ==(Object other) => other is Comment && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
