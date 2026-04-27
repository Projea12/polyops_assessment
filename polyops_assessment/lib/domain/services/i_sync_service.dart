import '../entities/sync_conflict.dart';

abstract interface class ISyncService {
  Stream<List<SyncConflict>> get conflictsStream;
  List<SyncConflict> get conflicts;
  Future<void> sync();
  Future<void> resolveConflict(SyncConflict conflict, {required bool keepLocal});
}
