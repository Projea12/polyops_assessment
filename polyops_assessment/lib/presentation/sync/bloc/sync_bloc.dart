import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/services/i_sync_service.dart';
import 'sync_event.dart';
import 'sync_state.dart';

export 'sync_event.dart';
export 'sync_state.dart';

// Internal startup event — subscribes to the conflicts stream via emit.forEach.
final class _SyncStarted extends SyncEvent {
  const _SyncStarted();
}

@injectable
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final ISyncService _syncService;

  SyncBloc(this._syncService)
      : super(SyncState(conflicts: _syncService.conflicts)) {
    on<_SyncStarted>(_onStarted, transformer: restartable());
    on<SyncTriggered>(_onSyncTriggered, transformer: droppable());
    on<ConflictResolved>(_onConflictResolved, transformer: sequential());
    add(const _SyncStarted());
  }

  Future<void> _onStarted(
    _SyncStarted event,
    Emitter<SyncState> emit,
  ) async {
    await emit.forEach(
      _syncService.conflictsStream,
      onData: (conflicts) => state.copyWith(conflicts: conflicts),
    );
  }

  Future<void> _onSyncTriggered(
    SyncTriggered event,
    Emitter<SyncState> emit,
  ) async {
    emit(state.copyWith(isSyncing: true));
    await _syncService.sync();
    emit(state.copyWith(isSyncing: false));
  }

  Future<void> _onConflictResolved(
    ConflictResolved event,
    Emitter<SyncState> emit,
  ) async {
    await _syncService.resolveConflict(
      event.conflict,
      keepLocal: event.keepLocal,
    );
  }
}
