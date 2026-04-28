import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' hide Task;
import 'package:mocktail/mocktail.dart';
import 'package:polyops_assessment/domain/entities/task_priority.dart';
import 'package:polyops_assessment/domain/entities/task_status.dart';
import 'package:polyops_assessment/presentation/task/task_detail/bloc/task_detail_bloc.dart';

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
        final task1 = makeTask(title: 'First', updatedAt: DateTime(2025, 1, 1));
        final task2 = makeTask(title: 'Updated', updatedAt: DateTime(2025, 1, 2));
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

  group('TaskDetailEditEntered', () {
    blocTest<TaskDetailBloc, TaskDetailState>(
      'does nothing when state is not TaskDetailLoaded',
      build: makeBloc,
      act: (bloc) => bloc.add(const TaskDetailEditEntered()),
      expect: () => <TaskDetailState>[],
    );

    blocTest<TaskDetailBloc, TaskDetailState>(
      'sets isEditing=true and seeds draft fields from task',
      build: makeBloc,
      seed: () => TaskDetailLoaded(
        task: makeTask(
          priority: TaskPriority.high,
          status: TaskStatus.inProgress,
          dueDate: DateTime(2025, 6, 1),
        ),
      ),
      act: (bloc) => bloc.add(const TaskDetailEditEntered()),
      expect: () => [
        isA<TaskDetailLoaded>()
            .having((s) => s.isEditing, 'isEditing', isTrue)
            .having((s) => s.draftPriority, 'draftPriority', TaskPriority.high)
            .having((s) => s.draftStatus, 'draftStatus', TaskStatus.inProgress)
            .having((s) => s.draftDueDate, 'draftDueDate', DateTime(2025, 6, 1)),
      ],
    );
  });

  group('TaskDetailEditCancelled', () {
    blocTest<TaskDetailBloc, TaskDetailState>(
      'does nothing when state is not TaskDetailLoaded',
      build: makeBloc,
      act: (bloc) => bloc.add(const TaskDetailEditCancelled()),
      expect: () => <TaskDetailState>[],
    );

    blocTest<TaskDetailBloc, TaskDetailState>(
      'sets isEditing=false and clears all draft fields',
      build: makeBloc,
      seed: () => TaskDetailLoaded(
        task: makeTask(),
        isEditing: true,
        draftPriority: TaskPriority.critical,
        draftStatus: TaskStatus.done,
        draftDueDate: DateTime(2025, 6, 1),
      ),
      act: (bloc) => bloc.add(const TaskDetailEditCancelled()),
      expect: () => [
        isA<TaskDetailLoaded>()
            .having((s) => s.isEditing, 'isEditing', isFalse)
            .having((s) => s.draftPriority, 'draftPriority', isNull)
            .having((s) => s.draftStatus, 'draftStatus', isNull)
            .having((s) => s.draftDueDate, 'draftDueDate', isNull),
      ],
    );
  });

  group('TaskDetailStatusChanged', () {
    blocTest<TaskDetailBloc, TaskDetailState>(
      'updates draftStatus',
      build: makeBloc,
      seed: () => TaskDetailLoaded(task: makeTask(), isEditing: true),
      act: (bloc) => bloc.add(const TaskDetailStatusChanged(TaskStatus.done)),
      expect: () => [
        isA<TaskDetailLoaded>()
            .having((s) => s.draftStatus, 'draftStatus', TaskStatus.done),
      ],
    );
  });

  group('TaskDetailPriorityChanged', () {
    blocTest<TaskDetailBloc, TaskDetailState>(
      'updates draftPriority',
      build: makeBloc,
      seed: () => TaskDetailLoaded(task: makeTask(), isEditing: true),
      act: (bloc) =>
          bloc.add(const TaskDetailPriorityChanged(TaskPriority.critical)),
      expect: () => [
        isA<TaskDetailLoaded>()
            .having((s) => s.draftPriority, 'draftPriority', TaskPriority.critical),
      ],
    );
  });

  group('TaskDetailDueDateChanged', () {
    blocTest<TaskDetailBloc, TaskDetailState>(
      'updates draftDueDate when date is non-null',
      build: makeBloc,
      seed: () => TaskDetailLoaded(task: makeTask(), isEditing: true),
      act: (bloc) =>
          bloc.add(TaskDetailDueDateChanged(DateTime(2025, 12, 31))),
      expect: () => [
        isA<TaskDetailLoaded>().having(
          (s) => s.draftDueDate,
          'draftDueDate',
          DateTime(2025, 12, 31),
        ),
      ],
    );

    blocTest<TaskDetailBloc, TaskDetailState>(
      'clears draftDueDate when date is null',
      build: makeBloc,
      seed: () => TaskDetailLoaded(
        task: makeTask(),
        isEditing: true,
        draftDueDate: DateTime(2025, 6, 1),
      ),
      act: (bloc) => bloc.add(const TaskDetailDueDateChanged(null)),
      expect: () => [
        isA<TaskDetailLoaded>()
            .having((s) => s.draftDueDate, 'draftDueDate', isNull),
      ],
    );
  });
}
