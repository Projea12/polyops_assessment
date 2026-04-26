import 'package:async/async.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/board_task.dart';
import '../../../../domain/entities/task_status.dart';
import '../../../../domain/repositories/i_task_repository.dart';
import '../../../../domain/usecases/task/move_task_usecase.dart';
import 'board_event.dart';
import 'board_state.dart';

export 'board_event.dart';
export 'board_state.dart';

@injectable
class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final ITaskRepository _repository;
  final MoveTaskUseCase _moveTask;

  BoardBloc(this._repository, this._moveTask)
      : super(const BoardState.initial()) {
    on<LoadBoard>(_onLoadBoard, transformer: restartable());
    on<MoveTask>(_onMoveTask, transformer: sequential());
  }

  Future<void> _onLoadBoard(
    LoadBoard event,
    Emitter<BoardState> emit,
  ) async {
    emit(const BoardState.loading());
    emit(BoardState.loaded(columns: {
      TaskStatus.todo: [],
      TaskStatus.inProgress: [],
      TaskStatus.done: [],
    }));

    final merged = StreamGroup.merge(
      TaskStatus.values.map(
        (s) => _repository
            .watchBoardTasksByStatus(s)
            .map<({TaskStatus status, List<BoardTask> tasks})>(
              (tasks) => (status: s, tasks: tasks),
            ),
      ),
    );

    await emit.forEach(
      merged,
      onData: (record) {
        final current = state;
        if (current is! BoardLoaded) return state;
        final updated =
            Map<TaskStatus, List<BoardTask>>.from(current.columns);
        updated[record.status] = record.tasks;
        return current.copyWith(columns: updated);
      },
      onError: (error, _) => BoardState.error(error.toString()),
    );
  }

  Future<void> _onMoveTask(
    MoveTask event,
    Emitter<BoardState> emit,
  ) async {
    final current = state;
    if (current is! BoardLoaded) return;

    final previousColumns =
        Map<TaskStatus, List<BoardTask>>.from(current.columns);

    emit(current.copyWith(
      columns: _applyOptimisticMove(current.columns, event),
      draggingTaskId: null,
      dragOverColumn: null,
    ));

    final result = await _moveTask(
      taskId: event.taskId,
      from: event.from,
      to: event.to,
      newPosition: event.newPosition,
    );

    result.fold(
      (failure) => emit(current.copyWith(columns: previousColumns)),
      (_) {},
    );
  }

  Map<TaskStatus, List<BoardTask>> _applyOptimisticMove(
    Map<TaskStatus, List<BoardTask>> columns,
    MoveTask event,
  ) {
    final updated =
        columns.map((k, v) => MapEntry(k, List<BoardTask>.from(v)));

    final fromList = updated[event.from] ?? [];
    final task = fromList.where((t) => t.id == event.taskId).firstOrNull;
    if (task == null) return columns;

    fromList.removeWhere((t) => t.id == event.taskId);
    updated[event.from] = fromList;

    final movedTask =
        task.copyWith(status: event.to, boardPosition: event.newPosition);
    final targetList = updated[event.to] ?? [];
    targetList.insert(
      event.newPosition.clamp(0, targetList.length),
      movedTask,
    );
    updated[event.to] = targetList;

    return updated;
  }
}
