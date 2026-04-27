import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polyops_assessment/domain/entities/task_status.dart';
import 'package:polyops_assessment/presentation/task/bloc/board_bloc.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  late MockWatchBoardTasksByStatusUseCase watchBoardTasks;
  late MockMoveTaskUseCase moveTask;

  setUp(() {
    watchBoardTasks = MockWatchBoardTasksByStatusUseCase();
    moveTask = MockMoveTaskUseCase();
  });

  setUpAll(() {
    registerFallbackValue(TaskStatus.todo);
  });

  BoardBloc makeBloc() => BoardBloc(watchBoardTasks, moveTask);

  void stubEmptyStreams() {
    when(() => watchBoardTasks(any()))
        .thenAnswer((_) => const Stream.empty());
  }

  group('initial state', () {
    test('is BoardInitial', () {
      expect(makeBloc().state, isA<BoardInitial>());
    });
  });

  group('LoadBoard', () {
    blocTest<BoardBloc, BoardState>(
      'emits [Loading, Loaded] with empty columns when streams emit nothing',
      build: makeBloc,
      setUp: stubEmptyStreams,
      act: (bloc) => bloc.add(const LoadBoard()),
      expect: () => [
        isA<BoardLoading>(),
        isA<BoardLoaded>().having(
          (s) => s.columns.values.every((tasks) => tasks.isEmpty),
          'all columns empty',
          isTrue,
        ),
      ],
    );

    blocTest<BoardBloc, BoardState>(
      'updates the correct column when a task stream emits',
      build: makeBloc,
      setUp: () {
        final todoTask = makeBoardTask(id: 'task-1', status: TaskStatus.todo);
        when(() => watchBoardTasks(TaskStatus.todo))
            .thenAnswer((_) => Stream.value([todoTask]));
        when(() => watchBoardTasks(TaskStatus.inProgress))
            .thenAnswer((_) => const Stream.empty());
        when(() => watchBoardTasks(TaskStatus.done))
            .thenAnswer((_) => const Stream.empty());
      },
      act: (bloc) => bloc.add(const LoadBoard()),
      expect: () => [
        isA<BoardLoading>(),
        isA<BoardLoaded>(),
        isA<BoardLoaded>().having(
          (s) => s.columns[TaskStatus.todo]!.length,
          'todo column count',
          1,
        ),
      ],
    );
  });

  group('MoveTask', () {
    final todoTask = makeBoardTask(id: 'task-1', status: TaskStatus.todo, boardPosition: 0);

    blocTest<BoardBloc, BoardState>(
      'applies optimistic move immediately before API call',
      build: makeBloc,
      seed: () => BoardState.loaded(columns: {
        TaskStatus.todo: [todoTask],
        TaskStatus.inProgress: [],
        TaskStatus.done: [],
      }),
      setUp: () {
        when(() => moveTask(
          taskId: any(named: 'taskId'),
          from: any(named: 'from'),
          to: any(named: 'to'),
          newPosition: any(named: 'newPosition'),
        )).thenAnswer((_) async => ok(makeTask()));
      },
      act: (bloc) => bloc.add(const MoveTask(
        taskId: 'task-1',
        from: TaskStatus.todo,
        to: TaskStatus.inProgress,
        newPosition: 0,
      )),
      expect: () => [
        isA<BoardLoaded>().having(
          (s) => s.columns[TaskStatus.todo]!.isEmpty,
          'todo column empty after move',
          isTrue,
        ).having(
          (s) => s.columns[TaskStatus.inProgress]!.length,
          'inProgress column has task',
          1,
        ),
      ],
    );

    blocTest<BoardBloc, BoardState>(
      'reverts to previous columns when move fails',
      build: makeBloc,
      seed: () => BoardState.loaded(columns: {
        TaskStatus.todo: [todoTask],
        TaskStatus.inProgress: [],
        TaskStatus.done: [],
      }),
      setUp: () {
        when(() => moveTask(
          taskId: any(named: 'taskId'),
          from: any(named: 'from'),
          to: any(named: 'to'),
          newPosition: any(named: 'newPosition'),
        )).thenAnswer((_) async => failWith('Move failed'));
      },
      act: (bloc) => bloc.add(const MoveTask(
        taskId: 'task-1',
        from: TaskStatus.todo,
        to: TaskStatus.inProgress,
        newPosition: 0,
      )),
      expect: () => [
        // Optimistic move applied
        isA<BoardLoaded>().having(
          (s) => s.columns[TaskStatus.inProgress]!.length,
          'inProgress has task optimistically',
          1,
        ),
        // Reverted on failure
        isA<BoardLoaded>().having(
          (s) => s.columns[TaskStatus.todo]!.length,
          'todo restored after failure',
          1,
        ).having(
          (s) => s.columns[TaskStatus.inProgress]!.isEmpty,
          'inProgress empty after revert',
          isTrue,
        ),
      ],
    );

    blocTest<BoardBloc, BoardState>(
      'does nothing when state is not BoardLoaded',
      build: makeBloc,
      act: (bloc) => bloc.add(const MoveTask(
        taskId: 'task-1',
        from: TaskStatus.todo,
        to: TaskStatus.inProgress,
        newPosition: 0,
      )),
      expect: () => <BoardState>[],
    );
  });
}
