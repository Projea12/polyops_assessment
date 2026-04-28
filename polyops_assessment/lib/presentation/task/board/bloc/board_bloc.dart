import 'package:async/async.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/entities/board_task.dart';
import '../../../../../domain/entities/task_status.dart';
import '../../../../../domain/usecases/task/move_task_usecase.dart';
import '../../../../../domain/usecases/task/watch_board_tasks_usecase.dart';
import 'board_event.dart';
import 'board_state.dart';

export 'board_event.dart';
export 'board_state.dart';

@injectable
class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final WatchBoardTasksByStatusUseCase _watchBoardTasks;
  final MoveTaskUseCase _moveTask;

  static const _edgeScrollThreshold = 80.0;
  static const _edgeScrollSpeed = 300.0;

  final Map<TaskStatus, ScrollController> _scrollControllers = {
    for (final s in TaskStatus.values) s: ScrollController(),
  };
  final Map<TaskStatus, bool> _isAutoScrolling = {
    for (final s in TaskStatus.values) s: false,
  };

  BoardBloc(this._watchBoardTasks, this._moveTask)
      : super(const BoardState.initial()) {
    on<LoadBoard>(_onLoadBoard, transformer: restartable());
    on<MoveTask>(_onMoveTask, transformer: sequential());
    on<DragStarted>(_onDragStarted, transformer: droppable());
    on<DragEnded>(_onDragEnded, transformer: droppable());
    on<HoverColumn>(_onHoverColumn, transformer: droppable());
  }

  ScrollController scrollControllerFor(TaskStatus status) =>
      _scrollControllers[status]!;

  void handlePointerMove(
    TaskStatus status,
    Offset globalPosition,
    RenderBox? renderBox,
  ) {
    final controller = _scrollControllers[status]!;
    if (!controller.hasClients || renderBox == null) return;
    final local = renderBox.globalToLocal(globalPosition);
    final height = renderBox.size.height;
    if (local.dy < _edgeScrollThreshold) {
      _startAutoScroll(status, -_edgeScrollSpeed);
    } else if (local.dy > height - _edgeScrollThreshold) {
      _startAutoScroll(status, _edgeScrollSpeed);
    } else {
      stopAutoScroll(status);
    }
  }

  void stopAutoScroll(TaskStatus status) {
    _isAutoScrolling[status] = false;
  }

  void _startAutoScroll(TaskStatus status, double speed) {
    if (_isAutoScrolling[status]!) return;
    _isAutoScrolling[status] = true;
    _autoScrollTick(status, speed);
  }

  void _autoScrollTick(TaskStatus status, double speed) {
    if (!(_isAutoScrolling[status]!)) return;
    final controller = _scrollControllers[status]!;
    if (!controller.hasClients) return;
    final target = (controller.offset + speed / 60).clamp(
      0.0,
      controller.position.maxScrollExtent,
    );
    controller.jumpTo(target);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoScrollTick(status, speed);
    });
  }

  @override
  Future<void> close() {
    for (final c in _scrollControllers.values) {
      c.dispose();
    }
    return super.close();
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
        (s) => _watchBoardTasks(s)
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

  void _onDragStarted(DragStarted event, Emitter<BoardState> emit) {
    final current = state;
    if (current is! BoardLoaded) return;
    emit(current.copyWith(draggingTaskId: event.taskId));
  }

  void _onDragEnded(DragEnded event, Emitter<BoardState> emit) {
    final current = state;
    if (current is! BoardLoaded) return;
    emit(current.copyWith(draggingTaskId: null, dragOverColumn: null));
  }

  void _onHoverColumn(HoverColumn event, Emitter<BoardState> emit) {
    final current = state;
    if (current is! BoardLoaded) return;
    if (current.dragOverColumn == event.status) return;
    emit(current.copyWith(dragOverColumn: event.status));
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
