// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dao.dart';

// ignore_for_file: type=lint
mixin _$TaskDaoMixin on DatabaseAccessor<AppDatabase> {
  $TasksTableTable get tasksTable => attachedDatabase.tasksTable;
  $CommentsTableTable get commentsTable => attachedDatabase.commentsTable;
  $ActivityEntriesTableTable get activityEntriesTable =>
      attachedDatabase.activityEntriesTable;
  TaskDaoManager get managers => TaskDaoManager(this);
}

class TaskDaoManager {
  final _$TaskDaoMixin _db;
  TaskDaoManager(this._db);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db.attachedDatabase, _db.tasksTable);
  $$CommentsTableTableTableManager get commentsTable =>
      $$CommentsTableTableTableManager(_db.attachedDatabase, _db.commentsTable);
  $$ActivityEntriesTableTableTableManager get activityEntriesTable =>
      $$ActivityEntriesTableTableTableManager(
        _db.attachedDatabase,
        _db.activityEntriesTable,
      );
}
