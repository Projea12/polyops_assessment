class SyncConflict {
  final String taskId;
  final String taskTitle;
  final String fieldName;
  final String localValue;
  final String serverValue;
  final DateTime localUpdatedAt;
  final DateTime serverUpdatedAt;
  final String serverActorName;

  const SyncConflict({
    required this.taskId,
    required this.taskTitle,
    required this.fieldName,
    required this.localValue,
    required this.serverValue,
    required this.localUpdatedAt,
    required this.serverUpdatedAt,
    required this.serverActorName,
  });
}
