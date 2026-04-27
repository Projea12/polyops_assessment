import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/stream_extensions.dart';
import '../../domain/entities/activity_entry.dart';
import '../../domain/entities/board_task.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../../domain/entities/task_status.dart';
import '../../domain/failures/failures.dart';
import '../../domain/entities/outbox_entry.dart';
import '../../domain/repositories/i_task_repository.dart';
import '../datasources/local/app_database.dart';
import '../datasources/local/outbox_dao.dart';
import '../datasources/local/task_dao.dart';

@LazySingleton(as: ITaskRepository)
class TaskRepository implements ITaskRepository {
  final TaskDao _dao;
  final OutboxDao _outboxDao;
  final _uuid = const Uuid();

  static const _currentUserId = 'user_01';
  static const _currentUserName = 'John';
  static const _clientId = 'client_01';

  TaskRepository(this._dao, this._outboxDao);

  OutboxTableCompanion _outbox(
    String taskId,
    OutboxOperation op,
    Map<String, dynamic> payload,
  ) =>
      OutboxTableCompanion.insert(
        id: _uuid.v4(),
        taskId: taskId,
        operation: op.name,
        payload: jsonEncode(payload),
        clientId: _clientId,
        createdAt: DateTime.now(),
      );

  @override
  Stream<List<BoardTask>> watchBoardTasksByStatus(TaskStatus status) =>
      _dao
          .watchBoardTasksByStatus(status.columnId)
          .debounceTime(const Duration(milliseconds: 100))
          .map((rows) => rows.map((r) => _mapToBoardTask(r.task, r.commentCount)).toList());

  @override
  Stream<List<Task>> watchTasksByStatus(TaskStatus status) =>
      _dao.watchTasksByStatus(status.columnId).asyncMap((rows) async {
        final tasks = <Task>[];
        for (final row in rows) {
          final comments = await _dao.getCommentsForTask(row.id);
          final activity = await _dao.getActivityForTask(row.id);
          tasks.add(_mapToTask(row, comments, activity));
        }
        return tasks;
      });

  @override
  Stream<Task> watchTask(String id) =>
      _dao.watchTask(id).asyncMap((row) async {
        final comments = await _dao.getCommentsForTask(row.id);
        final activity = await _dao.getActivityForTask(row.id);
        return _mapToTask(row, comments, activity);
      });

  @override
  Future<Either<Failure, Task>> getTask(String id) async {
    try {
      final row = await _dao.getTask(id);
      if (row == null) return left(const NotFoundFailure());
      final comments = await _dao.getCommentsForTask(id);
      final activity = await _dao.getActivityForTask(id);
      return right(_mapToTask(row, comments, activity));
    } catch (e, st) {
      debugPrint('[TaskRepository.getTask] $e\n$st');
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getAllTasks() async {
    try {
      final rows = await _dao.getAllTasks();
      final tasks = <Task>[];
      for (final row in rows) {
        final comments = await _dao.getCommentsForTask(row.id);
        final activity = await _dao.getActivityForTask(row.id);
        tasks.add(_mapToTask(row, comments, activity));
      }
      return right(tasks);
    } catch (e, st) {
      debugPrint('[TaskRepository.getAllTasks] $e\n$st');
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask({
    required String title,
    required String description,
    String? richDescription,
    required String priority,
    DateTime? dueDate,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now();

      await _dao.db.transaction(() async {
        await _dao.insertTask(TasksTableCompanion.insert(
          id: id,
          title: title,
          description: description,
          richDescription: Value(richDescription),
          status: TaskStatus.todo.columnId,
          priority: priority,
          boardPosition: 0,
          createdAt: now,
          updatedAt: now,
          dueDate: Value(dueDate),
          isPending: const Value(true),
        ));
        await _dao.insertActivity(ActivityEntriesTableCompanion.insert(
          id: _uuid.v4(),
          taskId: id,
          actorId: _currentUserId,
          actorName: _currentUserName,
          action: ActivityAction.taskCreated.name,
          metadata: jsonEncode({}),
          timestamp: now,
        ));
        await _outboxDao.insertEntry(_outbox(id, OutboxOperation.taskCreated, {
          'title': title,
          'description': description,
          'priority': priority,
          'dueDate': dueDate?.toIso8601String(),
        }));
      });

      final row = await _dao.getTask(id);
      return right(_mapToTask(row!, [], []));
    } catch (e, st) {
      debugPrint('[TaskRepository.createTask] $e\n$st');
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      final now = DateTime.now();

      await _dao.db.transaction(() async {
        await _dao.updateTask(TasksTableCompanion(
          id: Value(task.id),
          title: Value(task.title),
          description: Value(task.description),
          richDescription: Value(task.richDescription),
          status: Value(task.status.columnId),
          priority: Value(task.priority.name),
          boardPosition: Value(task.boardPosition),
          dueDate: Value(task.dueDate),
          isPending: const Value(true),
          updatedAt: Value(now),
        ));
        await _dao.insertActivity(ActivityEntriesTableCompanion.insert(
          id: _uuid.v4(),
          taskId: task.id,
          actorId: _currentUserId,
          actorName: _currentUserName,
          action: ActivityAction.taskUpdated.name,
          metadata: jsonEncode({}),
          timestamp: now,
        ));
        await _outboxDao.insertEntry(
            _outbox(task.id, OutboxOperation.taskUpdated, {
          'title': task.title,
          'description': task.description,
          'priority': task.priority.name,
          'status': task.status.columnId,
          'dueDate': task.dueDate?.toIso8601String(),
        }));
      });

      final updated = await _dao.getTask(task.id);
      final comments = await _dao.getCommentsForTask(task.id);
      final activity = await _dao.getActivityForTask(task.id);
      return right(_mapToTask(updated!, comments, activity));
    } catch (e, st) {
      debugPrint('[TaskRepository.updateTask] $e\n$st');
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> moveTask({
    required String taskId,
    required TaskStatus from,
    required TaskStatus to,
    required int newPosition,
  }) async {
    try {
      final now = DateTime.now();

      await _dao.db.transaction(() async {
        await _dao.updateTaskPosition(taskId, to.columnId, newPosition);
        await _dao.insertActivity(ActivityEntriesTableCompanion.insert(
          id: _uuid.v4(),
          taskId: taskId,
          actorId: _currentUserId,
          actorName: _currentUserName,
          action: ActivityAction.taskMoved.name,
          metadata: jsonEncode({'from': from.label, 'to': to.label}),
          timestamp: now,
        ));
        await _outboxDao.insertEntry(
            _outbox(taskId, OutboxOperation.taskMoved, {
          'from': from.columnId,
          'to': to.columnId,
          'newPosition': newPosition,
        }));
      });

      final updated = await _dao.getTask(taskId);
      final comments = await _dao.getCommentsForTask(taskId);
      final activity = await _dao.getActivityForTask(taskId);
      return right(_mapToTask(updated!, comments, activity));
    } catch (e, st) {
      debugPrint('[TaskRepository.moveTask] $e\n$st');
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String id) async {
    try {
      await _dao.db.transaction(() async {
        await _outboxDao.insertEntry(
            _outbox(id, OutboxOperation.taskDeleted, {}));
        await _dao.deleteActivitiesForTask(id);
        await _dao.deleteCommentsForTask(id);
        await _dao.deleteTask(id);
      });
      return right(unit);
    } catch (e, st) {
      debugPrint('[TaskRepository.deleteTask] $e\n$st');
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Comment>> addComment({
    required String taskId,
    required String content,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now();

      await _dao.insertComment(CommentsTableCompanion.insert(
        id: id,
        taskId: taskId,
        authorId: _currentUserId,
        authorName: _currentUserName,
        content: content,
        createdAt: now,
      ));

      await _dao.insertActivity(ActivityEntriesTableCompanion.insert(
        id: _uuid.v4(),
        taskId: taskId,
        actorId: _currentUserId,
        actorName: _currentUserName,
        action: ActivityAction.commentAdded.name,
        metadata: jsonEncode({}),
        timestamp: now,
      ));

      // Touch the task so watchTask stream re-emits with fresh comments
      await _dao.touchTask(taskId);

      return right(Comment(
        id: id,
        taskId: taskId,
        authorId: _currentUserId,
        authorName: _currentUserName,
        content: content,
        createdAt: now,
      ));
    } catch (e, st) {
      debugPrint('[TaskRepository.addComment] $e\n$st');
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteComment({
    required String taskId,
    required String commentId,
  }) async {
    try {
      await _dao.deleteComment(commentId);
      return right(unit);
    } catch (e, st) {
      debugPrint('[TaskRepository.deleteComment] $e\n$st');
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Stream<List<ActivityEntry>> watchActivityForTask(String taskId) =>
      _dao.watchActivityForTask(taskId).map(
            (rows) => rows.map(_mapToActivityEntry).toList(),
          );

  // --- Mappers ---

  BoardTask _mapToBoardTask(TasksTableData row, int commentCount) => BoardTask(
        id: row.id,
        title: row.title,
        description: row.description,
        status: _parseStatus(row.status),
        priority: _parsePriority(row.priority),
        dueDate: row.dueDate,
        boardPosition: row.boardPosition,
        updatedAt: row.updatedAt,
        commentCount: commentCount,
        isPending: row.isPending,
      );

  Task _mapToTask(
    TasksTableData row,
    List<CommentsTableData> comments,
    List<ActivityEntriesTableData> activity,
  ) {
    return Task(
      id: row.id,
      title: row.title,
      description: row.description,
      richDescription: row.richDescription,
      status: _parseStatus(row.status),
      priority: _parsePriority(row.priority),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      dueDate: row.dueDate,
      isPending: row.isPending,
      boardPosition: row.boardPosition,
      comments: comments.map(_mapToComment).toList(),
      activityHistory: activity.map(_mapToActivityEntry).toList(),
    );
  }

  Comment _mapToComment(CommentsTableData row) => Comment(
        id: row.id,
        taskId: row.taskId,
        authorId: row.authorId,
        authorName: row.authorName,
        content: row.content,
        createdAt: row.createdAt,
        editedAt: row.editedAt,
      );

  ActivityEntry _mapToActivityEntry(ActivityEntriesTableData row) =>
      ActivityEntry(
        id: row.id,
        taskId: row.taskId,
        actorId: row.actorId,
        actorName: row.actorName,
        action: ActivityAction.values.byName(row.action),
        metadata: jsonDecode(row.metadata) as Map<String, dynamic>,
        timestamp: row.timestamp,
      );

  TaskStatus _parseStatus(String value) => switch (value) {
        'in_progress' => TaskStatus.inProgress,
        'done' => TaskStatus.done,
        _ => TaskStatus.todo,
      };

  TaskPriority _parsePriority(String value) => switch (value) {
        'medium' => TaskPriority.medium,
        'high' => TaskPriority.high,
        'critical' => TaskPriority.critical,
        _ => TaskPriority.low,
      };
}
