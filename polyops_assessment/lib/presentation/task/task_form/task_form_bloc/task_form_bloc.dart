import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/usecases/task/create_task_usecase.dart';
import 'task_form_event.dart';
import 'task_form_state.dart';

export 'task_form_event.dart';
export 'task_form_state.dart';

@injectable
class TaskFormBloc extends Bloc<TaskFormEvent, TaskFormState> {
  final CreateTaskUseCase _createTask;

  TaskFormBloc(this._createTask) : super(const TaskFormIdle()) {
    on<TaskFormSubmitted>(_onSubmitted, transformer: droppable());
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
}
