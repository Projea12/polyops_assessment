import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' hide Task;
import 'package:mocktail/mocktail.dart';
import 'package:polyops_assessment/presentation/task/bloc/task_detail_bloc.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  late MockWatchTaskUseCase watchTask;
  late MockUpdateTaskUseCase updateTask;
  late MockDeleteTaskUseCase deleteTask;
  late MockAddCommentUseCase addComment;

  setUp(() {
    watchTask = MockWatchTaskUseCase();
    updateTask = MockUpdateTaskUseCase();
    deleteTask = MockDeleteTaskUseCase();
    addComment = MockAddCommentUseCase();
  });

  setUpAll(() {
    registerFallbackValue(makeTask());
    registerFallbackValue(makeComment());
  });

  TaskDetailBloc makeBloc() =>
      TaskDetailBloc(watchTask, updateTask, deleteTask, addComment);

  group('initial state', () {
    test('is TaskDetailInitial', () {
      expect(makeBloc().state, isA<TaskDetailInitial>());
    });
  });

  group('TaskDetailSubscribed', () {
    blocTest<TaskDetailBloc, TaskDetailState>(
      'emits [Loading, Loaded] when stream emits a task',
      build: makeBloc,
      setUp: () {
        final task = makeTask();
        when(() => watchTask(any())).thenAnswer((_) => Stream.value(task));
      },
      act: (bloc) => bloc.add(const TaskDetailSubscribed('task-1')),
      expect: () => [
        isA<TaskDetailLoading>(),
        isA<TaskDetailLoaded>(),
      ],
    );

    blocTest<TaskDetailBloc, TaskDetailState>(
      'loaded state contains the emitted task',
      build: makeBloc,
      setUp: () {
        final task = makeTask(title: 'My Task');
        when(() => watchTask(any())).thenAnswer((_) => Stream.value(task));
      },
      act: (bloc) => bloc.add(const TaskDetailSubscribed('task-1')),
      expect: () => [
        isA<TaskDetailLoading>(),
        isA<TaskDetailLoaded>().having((s) => s.task.title, 'title', 'My Task'),
      ],
    );

    blocTest<TaskDetailBloc, TaskDetailState>(
      'emits [Loading, Error] when stream throws',
      build: makeBloc,
      setUp: () {
        when(() => watchTask(any()))
            .thenAnswer((_) => Stream.error(Exception('DB error')));
      },
      act: (bloc) => bloc.add(const TaskDetailSubscribed('task-1')),
      expect: () => [
        isA<TaskDetailLoading>(),
        isA<TaskDetailError>().having((s) => s.message, 'message', contains('DB error')),
      ],
    );

    blocTest<TaskDetailBloc, TaskDetailState>(
      'stream re-emits update loaded state with new task data',
      build: makeBloc,
      setUp: () {
        final task1 = makeTask(title: 'First');
        final task2 = makeTask(title: 'Updated');
        when(() => watchTask(any()))
            .thenAnswer((_) => Stream.fromIterable([task1, task2]));
      },
      act: (bloc) => bloc.add(const TaskDetailSubscribed('task-1')),
      expect: () => [
        isA<TaskDetailLoading>(),
        isA<TaskDetailLoaded>().having((s) => s.task.title, 'title', 'First'),
        isA<TaskDetailLoaded>().having((s) => s.task.title, 'title', 'Updated'),
      ],
    );
  });

  group('TaskDetailSaveRequested', () {
    blocTest<TaskDetailBloc, TaskDetailState>(
      'does nothing when state is not TaskDetailLoaded',
      build: makeBloc,
      act: (bloc) => bloc.add(TaskDetailSaveRequested(makeTask())),
      expect: () => <TaskDetailState>[],
    );

    blocTest<TaskDetailBloc, TaskDetailState>(
      'emits isSaving=true then TaskDetailSaveSuccess on success',
      build: makeBloc,
      seed: () => TaskDetailLoaded(task: makeTask()),
      setUp: () {
        when(() => updateTask(any())).thenAnswer((_) async => ok(makeTask()));
      },
      act: (bloc) => bloc.add(TaskDetailSaveRequested(makeTask())),
      expect: () => [
        isA<TaskDetailLoaded>().having((s) => s.isSaving, 'isSaving', isTrue),
        isA<TaskDetailSaveSuccess>(),
      ],
    );

    blocTest<TaskDetailBloc, TaskDetailState>(
      'emits isSaving=true then loaded with operationError on failure',
      build: makeBloc,
      seed: () => TaskDetailLoaded(task: makeTask()),
      setUp: () {
        when(() => updateTask(any()))
            .thenAnswer((_) async => failWith('Save failed'));
      },
      act: (bloc) => bloc.add(TaskDetailSaveRequested(makeTask())),
      expect: () => [
        isA<TaskDetailLoaded>().having((s) => s.isSaving, 'isSaving', isTrue),
        isA<TaskDetailLoaded>()
            .having((s) => s.isSaving, 'isSaving', isFalse)
            .having((s) => s.operationError, 'operationError', 'Save failed'),
      ],
    );
  });

  group('TaskDetailDeleteRequested', () {
    blocTest<TaskDetailBloc, TaskDetailState>(
      'emits TaskDetailDeleteSuccess on success',
      build: makeBloc,
      seed: () => TaskDetailLoaded(task: makeTask()),
      setUp: () {
        when(() => deleteTask(any())).thenAnswer((_) async => ok(unit));
      },
      act: (bloc) => bloc.add(const TaskDetailDeleteRequested('task-1')),
      expect: () => [
        isA<TaskDetailLoaded>().having((s) => s.isSaving, 'isSaving', isTrue),
        isA<TaskDetailDeleteSuccess>(),
      ],
    );

    blocTest<TaskDetailBloc, TaskDetailState>(
      'emits operationError on failure',
      build: makeBloc,
      seed: () => TaskDetailLoaded(task: makeTask()),
      setUp: () {
        when(() => deleteTask(any()))
            .thenAnswer((_) async => failWith('Delete failed'));
      },
      act: (bloc) => bloc.add(const TaskDetailDeleteRequested('task-1')),
      expect: () => [
        isA<TaskDetailLoaded>().having((s) => s.isSaving, 'isSaving', isTrue),
        isA<TaskDetailLoaded>()
            .having((s) => s.operationError, 'operationError', 'Delete failed'),
      ],
    );
  });

  group('TaskDetailCommentSubmitted', () {
    blocTest<TaskDetailBloc, TaskDetailState>(
      'emits isSubmittingComment=true then false on success',
      build: makeBloc,
      seed: () => TaskDetailLoaded(task: makeTask()),
      setUp: () {
        when(() => addComment(taskId: any(named: 'taskId'), content: any(named: 'content')))
            .thenAnswer((_) async => ok(makeComment()));
      },
      act: (bloc) => bloc.add(
        const TaskDetailCommentSubmitted(taskId: 'task-1', content: 'Hello'),
      ),
      expect: () => [
        isA<TaskDetailLoaded>()
            .having((s) => s.isSubmittingComment, 'isSubmittingComment', isTrue),
        isA<TaskDetailLoaded>()
            .having((s) => s.isSubmittingComment, 'isSubmittingComment', isFalse),
      ],
    );

    blocTest<TaskDetailBloc, TaskDetailState>(
      'emits operationError on comment failure',
      build: makeBloc,
      seed: () => TaskDetailLoaded(task: makeTask()),
      setUp: () {
        when(() => addComment(taskId: any(named: 'taskId'), content: any(named: 'content')))
            .thenAnswer((_) async => failWith('Comment failed'));
      },
      act: (bloc) => bloc.add(
        const TaskDetailCommentSubmitted(taskId: 'task-1', content: 'Hello'),
      ),
      expect: () => [
        isA<TaskDetailLoaded>()
            .having((s) => s.isSubmittingComment, 'isSubmittingComment', isTrue),
        isA<TaskDetailLoaded>()
            .having((s) => s.isSubmittingComment, 'isSubmittingComment', isFalse)
            .having((s) => s.operationError, 'operationError', 'Comment failed'),
      ],
    );

    blocTest<TaskDetailBloc, TaskDetailState>(
      'does nothing when state is not TaskDetailLoaded',
      build: makeBloc,
      act: (bloc) => bloc.add(
        const TaskDetailCommentSubmitted(taskId: 'task-1', content: 'Hello'),
      ),
      expect: () => <TaskDetailState>[],
    );
  });
}
