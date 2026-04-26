import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/outbox_entry.dart';
import 'app_database.dart';

part 'outbox_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [OutboxTable, SyncMetaTable])
class OutboxDao extends DatabaseAccessor<AppDatabase> with _$OutboxDaoMixin {
  OutboxDao(super.db);

  static const _lastSyncKey = 'lastSyncAt';

  Future<void> insertEntry(OutboxTableCompanion entry) =>
      into(outboxTable).insert(entry);

  Future<List<OutboxTableData>> getPendingEntries() =>
      (select(outboxTable)
            ..where((t) => t.syncedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<void> markSynced(String id) =>
      (update(outboxTable)..where((t) => t.id.equals(id))).write(
        OutboxTableCompanion(syncedAt: Value(DateTime.now())),
      );

  Future<void> markSyncedForTask(String taskId) =>
      (update(outboxTable)..where((t) => t.taskId.equals(taskId))).write(
        OutboxTableCompanion(syncedAt: Value(DateTime.now())),
      );

  Future<void> clearSynced() =>
      (delete(outboxTable)..where((t) => t.syncedAt.isNotNull())).go();

  Future<DateTime?> getLastSyncAt() async {
    final row = await (select(syncMetaTable)
          ..where((t) => t.key.equals(_lastSyncKey)))
        .getSingleOrNull();
    if (row == null) return null;
    final ms = int.tryParse(row.value);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> setLastSyncAt(DateTime time) =>
      into(syncMetaTable).insertOnConflictUpdate(
        SyncMetaTableCompanion.insert(
          key: _lastSyncKey,
          value: time.millisecondsSinceEpoch.toString(),
        ),
      );

  OutboxEntry mapToEntry(OutboxTableData row) => OutboxEntry(
        id: row.id,
        taskId: row.taskId,
        operation: OutboxOperation.values.byName(row.operation),
        payload: jsonDecode(row.payload) as Map<String, dynamic>,
        clientId: row.clientId,
        createdAt: row.createdAt,
        syncedAt: row.syncedAt,
      );
}
