import '../../../domain/entities/sync_conflict.dart';

abstract class SyncEvent {
  const SyncEvent();
}

/// Dispatched on app init and on app lifecycle resume to flush the outbox.
final class SyncTriggered extends SyncEvent {
  const SyncTriggered();
}

/// Dispatched by the UI when the user resolves a conflict.
final class ConflictResolved extends SyncEvent {
  final SyncConflict conflict;
  final bool keepLocal;
  const ConflictResolved({required this.conflict, required this.keepLocal});
}
