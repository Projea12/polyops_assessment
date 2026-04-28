import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polyops_assessment/presentation/sync/bloc/sync_bloc.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  late MockISyncService syncService;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(makeSyncConflict());
  });

  setUp(() {
    syncService = MockISyncService();
    when(() => syncService.conflicts).thenReturn([]);
    when(() => syncService.conflictsStream).thenAnswer((_) => const Stream.empty());
  });

  SyncBloc makeBloc() => SyncBloc(syncService);

  group('initial state', () {
    test('seeds conflicts from ISyncService.conflicts', () {
      final conflict = makeSyncConflict();
      when(() => syncService.conflicts).thenReturn([conflict]);

      final bloc = makeBloc();
      expect(bloc.state.conflicts, [conflict]);
    });

    test('isSyncing is false initially', () {
      expect(makeBloc().state.isSyncing, isFalse);
    });
  });

  group('conflict stream subscription', () {
    blocTest<SyncBloc, SyncState>(
      'updates conflicts when conflictsStream emits',
      build: makeBloc,
      setUp: () {
        final conflict = makeSyncConflict();
        when(() => syncService.conflictsStream)
            .thenAnswer((_) => Stream.value([conflict]));
      },
      expect: () => [
        isA<SyncState>().having(
          (s) => s.conflicts.length,
          'conflicts count',
          1,
        ),
      ],
    );

    blocTest<SyncBloc, SyncState>(
      'clears conflicts when stream emits empty list',
      build: makeBloc,
      setUp: () {
        when(() => syncService.conflicts).thenReturn([makeSyncConflict()]);
        when(() => syncService.conflictsStream)
            .thenAnswer((_) => Stream.value([]));
      },
      expect: () => [
        isA<SyncState>().having((s) => s.conflicts, 'conflicts', isEmpty),
      ],
    );
  });

  group('SyncTriggered', () {
    blocTest<SyncBloc, SyncState>(
      'sets isSyncing=true then false around sync call',
      build: makeBloc,
      setUp: () {
        when(() => syncService.sync()).thenAnswer((_) async {});
      },
      act: (bloc) => bloc.add(const SyncTriggered()),
      expect: () => [
        isA<SyncState>().having((s) => s.isSyncing, 'isSyncing', isTrue),
        isA<SyncState>().having((s) => s.isSyncing, 'isSyncing', isFalse),
      ],
      verify: (_) {
        verify(() => syncService.sync()).called(1);
      },
    );

    blocTest<SyncBloc, SyncState>(
      'drops second SyncTriggered while first is in flight',
      build: makeBloc,
      setUp: () {
        when(() => syncService.sync()).thenAnswer(
          (_) => Future.delayed(const Duration(milliseconds: 50)),
        );
      },
      act: (bloc) async {
        bloc.add(const SyncTriggered());
        bloc.add(const SyncTriggered());
        await Future.delayed(const Duration(milliseconds: 100));
      },
      verify: (_) {
        // droppable() ensures sync() is called exactly once despite two events
        verify(() => syncService.sync()).called(1);
      },
    );
  });

  group('ConflictResolved', () {
    blocTest<SyncBloc, SyncState>(
      'calls resolveConflict with keepLocal=true',
      build: makeBloc,
      setUp: () {
        when(() => syncService.resolveConflict(any(), keepLocal: any(named: 'keepLocal')))
            .thenAnswer((_) async {});
      },
      act: (bloc) => bloc.add(ConflictResolved(
        conflict: makeSyncConflict(),
        keepLocal: true,
      )),
      verify: (_) {
        verify(() => syncService.resolveConflict(
          any(),
          keepLocal: true,
        )).called(1);
      },
    );

    blocTest<SyncBloc, SyncState>(
      'calls resolveConflict with keepLocal=false',
      build: makeBloc,
      setUp: () {
        when(() => syncService.resolveConflict(any(), keepLocal: any(named: 'keepLocal')))
            .thenAnswer((_) async {});
      },
      act: (bloc) => bloc.add(ConflictResolved(
        conflict: makeSyncConflict(),
        keepLocal: false,
      )),
      verify: (_) {
        verify(() => syncService.resolveConflict(
          any(),
          keepLocal: false,
        )).called(1);
      },
    );
  });
}
