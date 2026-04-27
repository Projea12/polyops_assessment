import '../../domain/entities/outbox_entry.dart';
import '../../domain/entities/sync_result.dart';

abstract class IRemoteTaskDataSource {
  Future<SyncResult> applyOperation(OutboxEntry entry);
}
