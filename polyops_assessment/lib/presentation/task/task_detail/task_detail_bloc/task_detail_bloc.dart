import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/task.dart';
import '../../../../domain/usecases/task/add_comment_usecase.dart';
import '../../../../domain/usecases/task/delete_task_usecase.dart';
import '../../../../domain/usecases/task/update_task_usecase.dart';
import '../../../../domain/usecases/task/watch_task_usecase.dart';
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

  QuillController quillController = QuillController.basic();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

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
    on<TaskDetailEditEntered>(_onEditEntered, transformer: droppable());
    on<TaskDetailEditCancelled>(_onEditCancelled, transformer: droppable());
    on<TaskDetailStatusChanged>(_onStatusChanged, transformer: droppable());
    on<TaskDetailPriorityChanged>(_onPriorityChanged, transformer: droppable());
    on<TaskDetailDueDateChanged>(_onDueDateChanged, transformer: droppable());
  }

  @override
  Future<void> close() {
    quillController.dispose();
    titleController.dispose();
    commentController.dispose();
    return super.close();
  }

  QuillController _buildQuillController(Task task) {
    if (task.richDescription != null) {
      try {
        final json = jsonDecode(task.richDescription!) as List;
        return QuillController(
          document: Document.fromJson(json),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (_) {}
    }
    if (task.description.isNotEmpty) {
      final doc = Document()..insert(0, task.description);
      return QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    return QuillController.basic();
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
        if (current is TaskDetailLoaded) {
          return current.copyWith(task: task, operationError: null);
        }
        // First emission: seed quillController with task content.
        quillController.dispose();
        quillController = _buildQuillController(task);
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
    emit(current.copyWith(isSaving: true, operationError: null));
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
    emit(current.copyWith(isSaving: true, operationError: null));
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
    emit(current.copyWith(isSubmittingComment: true, operationError: null));
    final result = await _addComment(taskId: event.taskId, content: event.content);
    result.fold(
      (failure) => emit(current.copyWith(isSubmittingComment: false, operationError: failure.message)),
      (_) => emit(current.copyWith(isSubmittingComment: false)),
    );
  }

  void _onEditEntered(TaskDetailEditEntered event, Emitter<TaskDetailState> emit) {
    final current = state;
    if (current is! TaskDetailLoaded) return;
    quillController.dispose();
    quillController = _buildQuillController(current.task);
    titleController.text = current.task.title;
    emit(current.copyWith(
      isEditing: true,
      draftPriority: current.task.priority,
      draftStatus: current.task.status,
      draftDueDate: current.task.dueDate,
    ));
  }

  void _onEditCancelled(TaskDetailEditCancelled event, Emitter<TaskDetailState> emit) {
    final current = state;
    if (current is! TaskDetailLoaded) return;
    quillController.dispose();
    quillController = _buildQuillController(current.task);
    emit(current.copyWith(isEditing: false, draftPriority: null, draftStatus: null, draftDueDate: null));
  }

  void _onStatusChanged(TaskDetailStatusChanged event, Emitter<TaskDetailState> emit) {
    final current = state;
    if (current is! TaskDetailLoaded) return;
    emit(current.copyWith(draftStatus: event.status));
  }

  void _onPriorityChanged(TaskDetailPriorityChanged event, Emitter<TaskDetailState> emit) {
    final current = state;
    if (current is! TaskDetailLoaded) return;
    emit(current.copyWith(draftPriority: event.priority));
  }

  void _onDueDateChanged(TaskDetailDueDateChanged event, Emitter<TaskDetailState> emit) {
    final current = state;
    if (current is! TaskDetailLoaded) return;
    if (event.date == null) {
      emit(current.copyWith(draftDueDate: null));
    } else {
      emit(current.copyWith(draftDueDate: event.date));
    }
  }
}
