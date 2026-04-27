import '../entities/outbox_entry.dart';
import '../entities/sync_result.dart';

abstract class IRemoteTaskDataSource {
  Future<SyncResult> applyOperation(OutboxEntry entry);
}
