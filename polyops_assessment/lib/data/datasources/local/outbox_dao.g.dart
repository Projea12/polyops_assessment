// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbox_dao.dart';

// ignore_for_file: type=lint
mixin _$OutboxDaoMixin on DatabaseAccessor<AppDatabase> {
  $OutboxTableTable get outboxTable => attachedDatabase.outboxTable;
  $SyncMetaTableTable get syncMetaTable => attachedDatabase.syncMetaTable;
  OutboxDaoManager get managers => OutboxDaoManager(this);
}

class OutboxDaoManager {
  final _$OutboxDaoMixin _db;
  OutboxDaoManager(this._db);
  $$OutboxTableTableTableManager get outboxTable =>
      $$OutboxTableTableTableManager(_db.attachedDatabase, _db.outboxTable);
  $$SyncMetaTableTableTableManager get syncMetaTable =>
      $$SyncMetaTableTableTableManager(_db.attachedDatabase, _db.syncMetaTable);
}
