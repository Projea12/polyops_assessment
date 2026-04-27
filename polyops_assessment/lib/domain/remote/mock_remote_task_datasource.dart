import 'dart:math';

import 'package:injectable/injectable.dart';

import '../entities/outbox_entry.dart';
import '../entities/sync_conflict.dart';
import '../entities/sync_result.dart';
import 'i_remote_task_datasource.dart';

@LazySingleton(as: IRemoteTaskDataSource)
class MockRemoteTaskDataSource implements IRemoteTaskDataSource {
  final _random = Random();

  @override
  Future<SyncResult> applyOperation(OutboxEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (entry.operation == OutboxOperation.taskUpdated &&
        _random.nextDouble() < 0.25) {
      final localTitle = entry.payload['title'] as String? ?? 'Untitled';
      return SyncConflicted(SyncConflict(
        taskId: entry.taskId,
        taskTitle: localTitle,
        fieldName: 'title',
        localValue: localTitle,
        serverValue: '$localTitle (edited by server)',
        localUpdatedAt: entry.createdAt,
        serverUpdatedAt: DateTime.now(),
        serverActorName: 'Alice',
      ));
    }

    return const SyncAccepted();
  }
}
