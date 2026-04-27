import '../../../domain/entities/sync_conflict.dart';

class SyncState {
  final List<SyncConflict> conflicts;
  final bool isSyncing;

  const SyncState({this.conflicts = const [], this.isSyncing = false});

  SyncState copyWith({List<SyncConflict>? conflicts, bool? isSyncing}) =>
      SyncState(
        conflicts: conflicts ?? this.conflicts,
        isSyncing: isSyncing ?? this.isSyncing,
      );
}
