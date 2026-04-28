import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_form_state.freezed.dart';

@freezed
sealed class TaskFormState with _$TaskFormState {
  const factory TaskFormState.idle() = TaskFormIdle;
  const factory TaskFormState.submitting() = TaskFormSubmitting;
  const factory TaskFormState.success() = TaskFormSuccess;
  const factory TaskFormState.failure(String message) = TaskFormFailure;
}
