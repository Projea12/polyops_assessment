import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/usecases/task/create_task_usecase.dart';
import 'task_form_event.dart';
import 'task_form_state.dart';

export 'task_form_event.dart';
export 'task_form_state.dart';

@injectable
class TaskFormBloc extends Bloc<TaskFormEvent, TaskFormState> {
  final CreateTaskUseCase _createTask;

  final TextEditingController titleController = TextEditingController();
  final QuillController quillController = QuillController.basic();
  final FocusNode titleFocus = FocusNode();

  TaskFormBloc(this._createTask) : super(const TaskFormIdle()) {
    on<TaskFormSubmitted>(_onSubmitted, transformer: droppable());
    on<TaskFormPriorityChanged>(_onPriorityChanged, transformer: droppable());
    on<TaskFormDueDateChanged>(_onDueDateChanged, transformer: droppable());
  }

  @override
  Future<void> close() {
    titleController.dispose();
    quillController.dispose();
    titleFocus.dispose();
    return super.close();
  }

  Future<void> _onSubmitted(
    TaskFormSubmitted event,
    Emitter<TaskFormState> emit,
  ) async {
    emit(const TaskFormSubmitting());
    final result = await _createTask(
      title: event.title,
      description: event.description,
      richDescription: event.richDescription,
      priority: event.priority,
      dueDate: event.dueDate,
    );
    result.fold(
      (failure) => emit(TaskFormFailure(failure.message)),
      (_) => emit(const TaskFormSuccess()),
    );
  }

  void _onPriorityChanged(
    TaskFormPriorityChanged event,
    Emitter<TaskFormState> emit,
  ) {
    final current = state;
    if (current is! TaskFormIdle) return;
    emit(current.copyWith(draftPriority: event.priority));
  }

  void _onDueDateChanged(
    TaskFormDueDateChanged event,
    Emitter<TaskFormState> emit,
  ) {
    final current = state;
    if (current is! TaskFormIdle) return;
    emit(current.copyWith(draftDueDate: event.dueDate));
  }

  void submit() {
    final current = state;
    if (current is! TaskFormIdle) return;
    final title = titleController.text.trim();
    if (title.isEmpty) {
      titleFocus.requestFocus();
      return;
    }
    add(TaskFormSubmitted(
      title: title,
      description: quillController.document.toPlainText().trim(),
      richDescription: jsonEncode(quillController.document.toDelta().toJson()),
      priority: current.draftPriority,
      dueDate: current.draftDueDate,
    ));
  }
}
