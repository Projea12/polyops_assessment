import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class TasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get richDescription => text().nullable()();
  TextColumn get status => text()(); // todo | in_progress | done
  TextColumn get priority => text()(); // low | medium | high | critical
  IntColumn get boardPosition => integer()();
  BoolColumn get isPending => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get dueDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class CommentsTable extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(TasksTable, #id)();
  TextColumn get authorId => text()();
  TextColumn get authorName => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get editedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ActivityEntriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(TasksTable, #id)();
  TextColumn get actorId => text()();
  TextColumn get actorName => text()();
  TextColumn get action => text()();
  TextColumn get metadata => text()(); // JSON encoded
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class OutboxTable extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  TextColumn get clientId => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncMetaTable extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@singleton
@DriftDatabase(
    tables: [TasksTable, CommentsTable, ActivityEntriesTable, OutboxTable, SyncMetaTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createIndexes();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(tasksTable, tasksTable.richDescription);
          }
          if (from < 3) {
            await _createIndexes();
          }
          if (from < 4) {
            await m.createTable(outboxTable);
            await m.createTable(syncMetaTable);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _createIndexes() async {
    final t = tasksTable.actualTableName;
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_tasks_status_position ON $t(status, board_position)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_tasks_status_updated ON $t(status, updated_at DESC)',
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'swamp.db'));
    return NativeDatabase.createInBackground(file);
  });
}
