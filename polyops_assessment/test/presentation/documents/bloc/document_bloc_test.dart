import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polyops_assessment/domain/entities/connectivity_status.dart';
import 'package:polyops_assessment/domain/entities/document_type.dart';
import 'package:polyops_assessment/presentation/documents/bloc/document_bloc.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  late MockWatchDocumentUseCase watchDocuments;
  late MockUploadDocumentUseCase uploadDocument;
  late MockIDocumentRepository documentRepository;

  setUp(() {
    watchDocuments = MockWatchDocumentUseCase();
    uploadDocument = MockUploadDocumentUseCase();
    documentRepository = MockIDocumentRepository();

    when(() => documentRepository.connectivityStatus)
        .thenReturn(ConnectivityStatus.offline);
    when(() => documentRepository.watchConnectivityStatus())
        .thenAnswer((_) => const Stream.empty());
  });

  setUpAll(() {
    registerFallbackValue(DocumentType.passport);
  });

  DocumentBloc makeBloc() =>
      DocumentBloc(watchDocuments, uploadDocument, documentRepository);

  group('initial state', () {
    test('is DocumentInitial', () {
      expect(makeBloc().state, isA<DocumentInitial>());
    });
  });

  group('DocumentSubscriptionRequested', () {
    blocTest<DocumentBloc, DocumentState>(
      'emits [Loading, Loaded] with seeded connectivity status',
      build: makeBloc,
      setUp: () {
        when(() => documentRepository.connectivityStatus)
            .thenReturn(ConnectivityStatus.live);
        when(() => watchDocuments.watchAll())
            .thenAnswer((_) => Stream.value([]));
      },
      act: (bloc) => bloc.add(const DocumentSubscriptionRequested()),
      expect: () => [
        isA<DocumentLoading>(),
        isA<DocumentLoaded>().having(
          (s) => s.connectivityStatus,
          'connectivity seeded from repository',
          ConnectivityStatus.live,
        ),
      ],
    );

    blocTest<DocumentBloc, DocumentState>(
      'updates documents when stream emits',
      build: makeBloc,
      setUp: () {
        final docs = [makeDocument(id: 'doc-1'), makeDocument(id: 'doc-2')];
        when(() => watchDocuments.watchAll())
            .thenAnswer((_) => Stream.value(docs));
      },
      act: (bloc) => bloc.add(const DocumentSubscriptionRequested()),
      expect: () => [
        isA<DocumentLoading>(),
        isA<DocumentLoaded>().having(
          (s) => s.documents.length,
          'document count',
          2,
        ),
      ],
    );

    blocTest<DocumentBloc, DocumentState>(
      'updates connectivity status when connectivity stream emits',
      build: makeBloc,
      setUp: () {
        // Docs stream must emit first so BLoC reaches DocumentLoaded.
        // ConnUpdate is silently ignored when state is not DocumentLoaded.
        when(() => watchDocuments.watchAll())
            .thenAnswer((_) => Stream.value([]));
        when(() => documentRepository.watchConnectivityStatus())
            .thenAnswer((_) => Stream.value(ConnectivityStatus.heartbeat));
      },
      act: (bloc) => bloc.add(const DocumentSubscriptionRequested()),
      expect: () => [
        isA<DocumentLoading>(),
        isA<DocumentLoaded>(), // from docs stream
        isA<DocumentLoaded>().having(
          (s) => s.connectivityStatus,
          'connectivity updated to heartbeat',
          ConnectivityStatus.heartbeat,
        ),
      ],
    );

    blocTest<DocumentBloc, DocumentState>(
      'emits Error when document stream throws',
      build: makeBloc,
      setUp: () {
        when(() => watchDocuments.watchAll())
            .thenAnswer((_) => Stream.error(Exception('Stream error')));
      },
      act: (bloc) => bloc.add(const DocumentSubscriptionRequested()),
      expect: () => [
        isA<DocumentLoading>(),
        isA<DocumentError>(),
      ],
    );
  });

  group('DocumentUploadRequested', () {
    blocTest<DocumentBloc, DocumentState>(
      'emits uploading then success with lastUploaded',
      build: makeBloc,
      seed: () => DocumentState.loaded(
        documents: [],
        connectivityStatus: ConnectivityStatus.live,
      ),
      setUp: () {
        final doc = makeDocument(id: 'uploaded-doc');
        when(() => uploadDocument(
          filePath: any(named: 'filePath'),
          type: any(named: 'type'),
        )).thenAnswer((_) async => ok(doc));
      },
      act: (bloc) => bloc.add(const DocumentUploadRequested(
        filePath: '/tmp/test.pdf',
        type: DocumentType.passport,
      )),
      expect: () => [
        isA<DocumentLoaded>().having(
          (s) => s.uploadStatus,
          'uploadStatus',
          DocumentUploadStatus.uploading,
        ),
        isA<DocumentLoaded>()
            .having((s) => s.uploadStatus, 'uploadStatus', DocumentUploadStatus.success)
            .having((s) => s.lastUploaded?.id, 'lastUploaded id', 'uploaded-doc'),
      ],
    );

    blocTest<DocumentBloc, DocumentState>(
      'emits uploading then failure with uploadError',
      build: makeBloc,
      seed: () => DocumentState.loaded(
        documents: [],
        connectivityStatus: ConnectivityStatus.live,
      ),
      setUp: () {
        when(() => uploadDocument(
          filePath: any(named: 'filePath'),
          type: any(named: 'type'),
        )).thenAnswer((_) async => failWith('Upload failed'));
      },
      act: (bloc) => bloc.add(const DocumentUploadRequested(
        filePath: '/tmp/test.pdf',
        type: DocumentType.passport,
      )),
      expect: () => [
        isA<DocumentLoaded>().having(
          (s) => s.uploadStatus,
          'uploadStatus',
          DocumentUploadStatus.uploading,
        ),
        isA<DocumentLoaded>()
            .having((s) => s.uploadStatus, 'uploadStatus', DocumentUploadStatus.failure)
            .having((s) => s.uploadError, 'uploadError', isNotNull),
      ],
    );

    blocTest<DocumentBloc, DocumentState>(
      'does nothing when state is not DocumentLoaded',
      build: makeBloc,
      act: (bloc) => bloc.add(const DocumentUploadRequested(
        filePath: '/tmp/test.pdf',
        type: DocumentType.passport,
      )),
      expect: () => <DocumentState>[],
    );
  });

  group('DocumentUploadStatusReset', () {
    blocTest<DocumentBloc, DocumentState>(
      'resets uploadStatus to idle and clears lastUploaded',
      build: makeBloc,
      seed: () => DocumentState.loaded(
        documents: [],
        uploadStatus: DocumentUploadStatus.success,
        lastUploaded: makeDocument(),
      ),
      act: (bloc) => bloc.add(const DocumentUploadStatusReset()),
      expect: () => [
        isA<DocumentLoaded>()
            .having((s) => s.uploadStatus, 'uploadStatus', DocumentUploadStatus.idle)
            .having((s) => s.lastUploaded, 'lastUploaded', isNull),
      ],
    );
  });
}
