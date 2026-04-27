import '../../../domain/entities/task.dart';

abstract class TaskDetailState {
  const TaskDetailState();
}

final class TaskDetailInitial extends TaskDetailState {
  const TaskDetailInitial();
}

final class TaskDetailLoading extends TaskDetailState {
  const TaskDetailLoading();
}

final class TaskDetailLoaded extends TaskDetailState {
  final Task task;
  final bool isSaving;
  final bool isSubmittingComment;

  /// Non-null when a save/comment operation fails. Consumed by BlocListener
  /// to show a snackbar; cleared on the next save attempt.
  final String? operationError;

  const TaskDetailLoaded({
    required this.task,
    this.isSaving = false,
    this.isSubmittingComment = false,
    this.operationError,
  });

  TaskDetailLoaded copyWith({
    Task? task,
    bool? isSaving,
    bool? isSubmittingComment,
    String? operationError,
    bool clearError = false,
  }) =>
      TaskDetailLoaded(
        task: task ?? this.task,
        isSaving: isSaving ?? this.isSaving,
        isSubmittingComment: isSubmittingComment ?? this.isSubmittingComment,
        operationError: clearError ? null : (operationError ?? this.operationError),
      );
}

final class TaskDetailSaveSuccess extends TaskDetailState {
  const TaskDetailSaveSuccess();
}

final class TaskDetailDeleteSuccess extends TaskDetailState {
  const TaskDetailDeleteSuccess();
}

final class TaskDetailError extends TaskDetailState {
  final String message;
  const TaskDetailError(this.message);
}
