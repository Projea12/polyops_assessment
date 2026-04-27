import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import 'app_database.dart';

part 'task_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [TasksTable, CommentsTable, ActivityEntriesTable])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  Stream<List<TasksTableData>> watchTasksByStatus(String status) =>
      (select(tasksTable)
            ..where((t) => t.status.equals(status))
            ..orderBy([
              (t) => OrderingTerm.asc(t.boardPosition),
              (t) => OrderingTerm.desc(t.updatedAt),
            ]))
          .watch();

  Stream<List<({TasksTableData task, int commentCount})>>
      watchBoardTasksByStatus(String status) {
    final count = commentsTable.id.count();
    final query = (select(tasksTable)
          ..where((t) => t.status.equals(status))
          ..orderBy([
            (t) => OrderingTerm.asc(t.boardPosition),
            (t) => OrderingTerm.desc(t.updatedAt),
          ]))
        .join([
          leftOuterJoin(
            commentsTable,
            commentsTable.taskId.equalsExp(tasksTable.id),
            useColumns: false,
          ),
        ]);
    query.addColumns([count]);
    query.groupBy([tasksTable.id]);
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => (
                  task: row.readTable(tasksTable),
                  commentCount: row.read(count) ?? 0,
                ),
              )
              .toList(),
        );
  }

  Stream<TasksTableData> watchTask(String id) =>
      (select(tasksTable)..where((t) => t.id.equals(id))).watchSingle();

  Future<TasksTableData?> getTask(String id) =>
      (select(tasksTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<TasksTableData>> getAllTasks() => select(tasksTable).get();

  Future<void> insertTask(TasksTableCompanion task) =>
      into(tasksTable).insert(task);

  Future<int> updateTask(TasksTableCompanion task) =>
      (update(tasksTable)..where((t) => t.id.equals(task.id.value)))
          .write(task);

  Future<int> deleteTask(String id) =>
      (delete(tasksTable)..where((t) => t.id.equals(id))).go();

  Stream<List<CommentsTableData>> watchCommentsForTask(String taskId) =>
      (select(commentsTable)
            ..where((c) => c.taskId.equals(taskId))
            ..orderBy([(c) => OrderingTerm.asc(c.createdAt)]))
          .watch();

  Future<void> insertComment(CommentsTableCompanion comment) =>
      into(commentsTable).insert(comment);

  Future<int> deleteComment(String commentId) =>
      (delete(commentsTable)..where((c) => c.id.equals(commentId))).go();

  Future<int> deleteCommentsForTask(String taskId) =>
      (delete(commentsTable)..where((c) => c.taskId.equals(taskId))).go();

  Future<int> deleteActivitiesForTask(String taskId) =>
      (delete(activityEntriesTable)
            ..where((a) => a.taskId.equals(taskId)))
          .go();

  Stream<List<ActivityEntriesTableData>> watchActivityForTask(String taskId) =>
      (select(activityEntriesTable)
            ..where((a) => a.taskId.equals(taskId))
            ..orderBy([(a) => OrderingTerm.desc(a.timestamp)]))
          .watch();

  Future<void> insertActivity(ActivityEntriesTableCompanion entry) =>
      into(activityEntriesTable).insert(entry);

  Future<List<CommentsTableData>> getCommentsForTask(String taskId) =>
      (select(commentsTable)
            ..where((c) => c.taskId.equals(taskId))
            ..orderBy([(c) => OrderingTerm.asc(c.createdAt)]))
          .get();

  Future<List<ActivityEntriesTableData>> getActivityForTask(String taskId) =>
      (select(activityEntriesTable)
            ..where((a) => a.taskId.equals(taskId))
            ..orderBy([(a) => OrderingTerm.desc(a.timestamp)]))
          .get();

  Future<void> setTaskPending(String id, bool isPending) =>
      (update(tasksTable)..where((t) => t.id.equals(id))).write(
        TasksTableCompanion(isPending: Value(isPending)),
      );

  Future<void> touchTask(String id) =>
      (update(tasksTable)..where((t) => t.id.equals(id))).write(
        TasksTableCompanion(updatedAt: Value(DateTime.now())),
      );

  Future<void> updateTaskField(String id, {String? title}) =>
      (update(tasksTable)..where((t) => t.id.equals(id))).write(
        TasksTableCompanion(
          title: title != null ? Value(title) : const Value.absent(),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> updateTaskPosition(
    String taskId,
    String newStatus,
    int newPosition,
  ) =>
      (update(tasksTable)..where((t) => t.id.equals(taskId))).write(
        TasksTableCompanion(
          status: Value(newStatus),
          boardPosition: Value(newPosition),
          updatedAt: Value(DateTime.now()),
          isPending: const Value(false),
        ),
      );
}
