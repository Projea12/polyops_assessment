abstract interface class INotificationService {
  Future<void> scheduleTaskDueNotification(
    String taskId,
    String title,
    DateTime dueDate,
  );
  Future<void> cancelTaskNotification(String taskId);
}
