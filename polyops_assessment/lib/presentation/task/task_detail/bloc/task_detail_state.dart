import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entities/task.dart';
import '../../../../domain/entities/task_priority.dart';
import '../../../../domain/entities/task_status.dart';

part 'task_detail_state.freezed.dart';

@freezed
sealed class TaskDetailState with _$TaskDetailState {
  const factory TaskDetailState.initial() = TaskDetailInitial;
  const factory TaskDetailState.loading() = TaskDetailLoading;

  const factory TaskDetailState.loaded({
    required Task task,
    @Default(false) bool isSaving,
    @Default(false) bool isSubmittingComment,
    @Default(false) bool isEditing,
    TaskPriority? draftPriority,
    TaskStatus? draftStatus,
    DateTime? draftDueDate,
    String? operationError,
  }) = TaskDetailLoaded;

  const factory TaskDetailState.saveSuccess() = TaskDetailSaveSuccess;
  const factory TaskDetailState.deleteSuccess() = TaskDetailDeleteSuccess;
  const factory TaskDetailState.error(String message) = TaskDetailError;
}
