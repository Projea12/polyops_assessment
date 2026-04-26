enum OutboxOperation {
  taskCreated,
  taskUpdated,
  taskDeleted,
  taskMoved,
  commentAdded,
  commentDeleted,
}

class OutboxEntry {
  final String id;
  final String taskId;
  final OutboxOperation operation;
  final Map<String, dynamic> payload;
  final String clientId;
  final DateTime createdAt;
  final DateTime? syncedAt;

  const OutboxEntry({
    required this.id,
    required this.taskId,
    required this.operation,
    required this.payload,
    required this.clientId,
    required this.createdAt,
    this.syncedAt,
  });

  bool get isPending => syncedAt == null;
}
