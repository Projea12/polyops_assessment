import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/sync_conflict.dart';

part 'sync_state.freezed.dart';

@freezed
sealed class SyncState with _$SyncState {
  const factory SyncState({
    @Default(<SyncConflict>[]) List<SyncConflict> conflicts,
    @Default(false) bool isSyncing,
    @Default(<String>{}) Set<String> resolvingIds,
  }) = _SyncState;
}
