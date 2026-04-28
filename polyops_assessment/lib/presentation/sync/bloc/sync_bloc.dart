import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/services/i_sync_service.dart';
import 'sync_event.dart';
import 'sync_state.dart';

export 'sync_event.dart';
export 'sync_state.dart';

@injectable
class SyncBloc extends Bloc<SyncEvent, SyncState> with WidgetsBindingObserver {
  final ISyncService _syncService;

  SyncBloc(this._syncService)
      : super(SyncState(conflicts: _syncService.conflicts)) {
    on<SyncStarted>(_onStarted, transformer: restartable());
    on<SyncTriggered>(_onSyncTriggered, transformer: droppable());
    on<ConflictResolved>(_onConflictResolved, transformer: sequential());
    add(const SyncStarted());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) add(const SyncTriggered());
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  Future<void> _onStarted(
    SyncStarted event,
    Emitter<SyncState> emit,
  ) async {
    await emit.forEach(
      _syncService.conflictsStream,
      onData: (conflicts) {
        final remaining = conflicts.map((c) => c.taskId).toSet();
        return state.copyWith(
          conflicts: conflicts,
          resolvingIds: state.resolvingIds.intersection(remaining),
        );
      },
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
    emit(state.copyWith(
      resolvingIds: {...state.resolvingIds, event.conflict.taskId},
    ));
    await _syncService.resolveConflict(
      event.conflict,
      keepLocal: event.keepLocal,
    );
  }
}
