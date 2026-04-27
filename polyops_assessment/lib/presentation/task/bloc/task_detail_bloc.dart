import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/task.dart';
import '../../../domain/usecases/task/add_comment_usecase.dart';
import '../../../domain/usecases/task/delete_task_usecase.dart';
import '../../../domain/usecases/task/update_task_usecase.dart';
import '../../../domain/usecases/task/watch_task_usecase.dart';
import 'task_detail_event.dart';
import 'task_detail_state.dart';

export 'task_detail_event.dart';
export 'task_detail_state.dart';

@injectable
class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final WatchTaskUseCase _watchTask;
  final UpdateTaskUseCase _updateTask;
  final DeleteTaskUseCase _deleteTask;
  final AddCommentUseCase _addComment;

  TaskDetailBloc(
    this._watchTask,
    this._updateTask,
    this._deleteTask,
    this._addComment,
  ) : super(const TaskDetailInitial()) {
    on<TaskDetailSubscribed>(_onSubscribed, transformer: restartable());
    on<TaskDetailSaveRequested>(_onSaveRequested, transformer: droppable());
    on<TaskDetailDeleteRequested>(_onDeleteRequested, transformer: droppable());
    on<TaskDetailCommentSubmitted>(_onCommentSubmitted, transformer: sequential());
  }

  Future<void> _onSubscribed(
    TaskDetailSubscribed event,
    Emitter<TaskDetailState> emit,
  ) async {
    emit(const TaskDetailLoading());
    await emit.forEach<Task>(
      _watchTask(event.taskId),
      onData: (task) {
        final current = state;
        if (current is TaskDetailLoaded) return current.copyWith(task: task, clearError: true);
        return TaskDetailLoaded(task: task);
      },
      onError: (e, _) => TaskDetailError(e.toString()),
    );
  }

  Future<void> _onSaveRequested(
    TaskDetailSaveRequested event,
    Emitter<TaskDetailState> emit,
  ) async {
    final current = state;
    if (current is! TaskDetailLoaded) return;
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await _updateTask(event.task);
    result.fold(
      (failure) => emit(current.copyWith(isSaving: false, operationError: failure.message)),
      (_) => emit(const TaskDetailSaveSuccess()),
    );
  }

  Future<void> _onDeleteRequested(
    TaskDetailDeleteRequested event,
    Emitter<TaskDetailState> emit,
  ) async {
    final current = state;
    if (current is! TaskDetailLoaded) return;
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await _deleteTask(event.taskId);
    result.fold(
      (failure) => emit(current.copyWith(isSaving: false, operationError: failure.message)),
      (_) => emit(const TaskDetailDeleteSuccess()),
    );
  }

  Future<void> _onCommentSubmitted(
    TaskDetailCommentSubmitted event,
    Emitter<TaskDetailState> emit,
  ) async {
    final current = state;
    if (current is! TaskDetailLoaded) return;
    emit(current.copyWith(isSubmittingComment: true, clearError: true));
    final result = await _addComment(taskId: event.taskId, content: event.content);
    result.fold(
      (failure) => emit(current.copyWith(isSubmittingComment: false, operationError: failure.message)),
      // Task stream updates comments reactively; just reset the loading flag.
      (_) => emit(current.copyWith(isSubmittingComment: false)),
    );
  }
}
