import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/sync_conflict.dart';

part 'sync_event.freezed.dart';

@freezed
sealed class SyncEvent with _$SyncEvent {
  /// Internal — dispatched once in [SyncBloc] constructor to start the conflicts stream subscription.
  const factory SyncEvent.started() = SyncStarted;

  /// Dispatched on app init and on app lifecycle resume to flush the outbox.
  const factory SyncEvent.triggered() = SyncTriggered;

  /// Dispatched by the UI when the user resolves a conflict.
  const factory SyncEvent.conflictResolved({
    required SyncConflict conflict,
    required bool keepLocal,
  }) = ConflictResolved;
}
