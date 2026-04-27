import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/local/outbox_dao.dart';
import '../../data/datasources/local/task_dao.dart';
import '../../data/remote/i_remote_task_datasource.dart';
import '../../domain/entities/sync_conflict.dart';
import '../../domain/entities/sync_result.dart';
import 'i_sync_service.dart';

@LazySingleton(as: ISyncService)
class SyncService implements ISyncService {
  final OutboxDao _outboxDao;
  final TaskDao _taskDao;
  final IRemoteTaskDataSource _remote;

  bool _isSyncing = false;
  final _conflictsController =
      StreamController<List<SyncConflict>>.broadcast();
  final List<SyncConflict> _conflicts = [];

  @override
  Stream<List<SyncConflict>> get conflictsStream =>
      _conflictsController.stream;
  @override
  List<SyncConflict> get conflicts => List.unmodifiable(_conflicts);
  bool get hasPendingConflicts => _conflicts.isNotEmpty;

  SyncService(this._outboxDao, this._taskDao, this._remote);

  @override
  Future<void> sync() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      await _doSync();
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _doSync() async {
    final rows = await _outboxDao.getPendingEntries();
    if (rows.isEmpty) return;

    final entries = rows.map(_outboxDao.mapToEntry).toList();

    for (final entry in entries) {
      try {
        final result = await _remote.applyOperation(entry);
        switch (result) {
          case SyncAccepted():
            await _outboxDao.markSynced(entry.id);
            await _taskDao.setTaskPending(entry.taskId, false);
          case SyncConflicted(:final conflict):
            final alreadyTracked = _conflicts.any(
              (c) => c.taskId == conflict.taskId && c.fieldName == conflict.fieldName,
            );
            if (!alreadyTracked) {
              _conflicts.add(conflict);
              _conflictsController.add(List.unmodifiable(_conflicts));
            }
        }
      } catch (e, st) {
        debugPrint('[SyncService] Failed to sync ${entry.id}: $e\n$st');
      }
    }

    await _outboxDao.clearSynced();
    await _outboxDao.setLastSyncAt(DateTime.now());
  }

  @override
  Future<void> resolveConflict(
    SyncConflict conflict, {
    required bool keepLocal,
  }) async {
    if (!keepLocal) {
      await _taskDao.updateTaskField(conflict.taskId, title: conflict.serverValue);
    }
    await _outboxDao.markSyncedForTask(conflict.taskId);
    await _taskDao.setTaskPending(conflict.taskId, false);
    _conflicts.removeWhere(
      (c) => c.taskId == conflict.taskId && c.fieldName == conflict.fieldName,
    );
    _conflictsController.add(List.unmodifiable(_conflicts));
  }

  static String buildTaskPayload(Map<String, dynamic> fields) =>
      jsonEncode(fields);

  void dispose() {
    _conflictsController.close();
  }
}
