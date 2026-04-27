// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_dao.dart';

// ignore_for_file: type=lint
mixin _$DocumentDaoMixin on DatabaseAccessor<AppDatabase> {
  $DocumentsTableTable get documentsTable => attachedDatabase.documentsTable;
  $DocumentAuditTableTable get documentAuditTable =>
      attachedDatabase.documentAuditTable;
  DocumentDaoManager get managers => DocumentDaoManager(this);
}

class DocumentDaoManager {
  final _$DocumentDaoMixin _db;
  DocumentDaoManager(this._db);
  $$DocumentsTableTableTableManager get documentsTable =>
      $$DocumentsTableTableTableManager(
        _db.attachedDatabase,
        _db.documentsTable,
      );
  $$DocumentAuditTableTableTableManager get documentAuditTable =>
      $$DocumentAuditTableTableTableManager(
        _db.attachedDatabase,
        _db.documentAuditTable,
      );
}
