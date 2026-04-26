import 'sync_conflict.dart';

sealed class SyncResult {
  const SyncResult();
}

final class SyncAccepted extends SyncResult {
  const SyncAccepted();
}

final class SyncConflicted extends SyncResult {
  final SyncConflict conflict;
  const SyncConflicted(this.conflict);
}
