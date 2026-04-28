import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polyops_assessment/domain/entities/connectivity_status.dart';
import 'package:polyops_assessment/domain/entities/document_type.dart';
import 'package:polyops_assessment/domain/entities/file_source.dart';
import 'package:polyops_assessment/domain/entities/selected_file.dart';
import 'package:polyops_assessment/presentation/documents/bloc/document_bloc.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  late MockWatchDocumentUseCase watchDocuments;
  late MockUploadDocumentUseCase uploadDocument;
  late MockIDocumentRepository documentRepository;
  late MockPickDocumentFileUseCase pickDocumentFile;

  setUp(() {
    watchDocuments = MockWatchDocumentUseCase();
    uploadDocument = MockUploadDocumentUseCase();
    documentRepository = MockIDocumentRepository();
    pickDocumentFile = MockPickDocumentFileUseCase();

    when(() => documentRepository.connectivityStatus)
        .thenReturn(ConnectivityStatus.offline);
    when(() => documentRepository.watchConnectivityStatus())
        .thenAnswer((_) => const Stream.empty());
  });

  setUpAll(() {
    registerFallbackValue(DocumentType.passport);
    registerFallbackValue(FileSource.gallery);
  });

  DocumentBloc makeBloc() => DocumentBloc(
        watchDocuments,
        uploadDocument,
        documentRepository,
        pickDocumentFile,
      );

  const draftFile = SelectedFile(
    path: '/tmp/test.pdf',
    name: 'test.pdf',
    size: 1024,
  );

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
        when(() => watchDocuments.watchAll())
            .thenAnswer((_) => Stream.value([]));
        when(() => documentRepository.watchConnectivityStatus())
            .thenAnswer((_) => Stream.value(ConnectivityStatus.heartbeat));
      },
      act: (bloc) => bloc.add(const DocumentSubscriptionRequested()),
      expect: () => [
        isA<DocumentLoading>(),
        isA<DocumentLoaded>(),
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

    blocTest<DocumentBloc, DocumentState>(
      'preserves draft state across stream updates',
      build: makeBloc,
      setUp: () {
        when(() => watchDocuments.watchAll())
            .thenAnswer((_) => Stream.value([]));
      },
      seed: () => DocumentState.loaded(
        documents: [],
        draftType: DocumentType.passport,
        draftFile: draftFile,
      ),
      act: (bloc) => bloc.add(const DocumentSubscriptionRequested()),
      expect: () => [
        isA<DocumentLoading>(),
        isA<DocumentLoaded>()
            .having((s) => s.draftType, 'draftType preserved', DocumentType.passport)
            .having((s) => s.draftFile, 'draftFile preserved', draftFile),
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
        draftType: DocumentType.passport,
        draftFile: draftFile,
      ),
      setUp: () {
        final doc = makeDocument(id: 'uploaded-doc');
        when(() => uploadDocument(
              filePath: any(named: 'filePath'),
              type: any(named: 'type'),
            )).thenAnswer((_) async => ok(doc));
      },
      act: (bloc) => bloc.add(const DocumentUploadRequested()),
      expect: () => [
        isA<DocumentLoaded>().having(
          (s) => s.uploadStatus,
          'uploadStatus',
          DocumentUploadStatus.uploading,
        ),
        isA<DocumentLoaded>()
            .having((s) => s.uploadStatus, 'uploadStatus',
                DocumentUploadStatus.success)
            .having((s) => s.lastUploaded?.id, 'lastUploaded id', 'uploaded-doc')
            .having((s) => s.draftFile, 'draft cleared on success', isNull)
            .having((s) => s.draftType, 'draft type cleared on success', isNull),
      ],
    );

    blocTest<DocumentBloc, DocumentState>(
      'emits uploading then failure with uploadError',
      build: makeBloc,
      seed: () => DocumentState.loaded(
        documents: [],
        connectivityStatus: ConnectivityStatus.live,
        draftType: DocumentType.passport,
        draftFile: draftFile,
      ),
      setUp: () {
        when(() => uploadDocument(
              filePath: any(named: 'filePath'),
              type: any(named: 'type'),
            )).thenAnswer((_) async => failWith('Upload failed'));
      },
      act: (bloc) => bloc.add(const DocumentUploadRequested()),
      expect: () => [
        isA<DocumentLoaded>().having(
          (s) => s.uploadStatus,
          'uploadStatus',
          DocumentUploadStatus.uploading,
        ),
        isA<DocumentLoaded>()
            .having((s) => s.uploadStatus, 'uploadStatus',
                DocumentUploadStatus.failure)
            .having((s) => s.uploadError, 'uploadError', isNotNull),
      ],
    );

    blocTest<DocumentBloc, DocumentState>(
      'does nothing when state is not DocumentLoaded',
      build: makeBloc,
      act: (bloc) => bloc.add(const DocumentUploadRequested()),
      expect: () => <DocumentState>[],
    );

    blocTest<DocumentBloc, DocumentState>(
      'does nothing when draft is incomplete',
      build: makeBloc,
      seed: () => DocumentState.loaded(
        documents: [],
        draftType: DocumentType.passport,
        // draftFile intentionally missing
      ),
      act: (bloc) => bloc.add(const DocumentUploadRequested()),
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
            .having((s) => s.uploadStatus, 'uploadStatus',
                DocumentUploadStatus.idle)
            .having((s) => s.lastUploaded, 'lastUploaded', isNull),
      ],
    );
  });

  group('DocumentTypeSelected', () {
    blocTest<DocumentBloc, DocumentState>(
      'updates draftType in state',
      build: makeBloc,
      seed: () => DocumentState.loaded(documents: []),
      act: (bloc) => bloc.add(const DocumentTypeSelected(DocumentType.passport)),
      expect: () => [
        isA<DocumentLoaded>()
            .having((s) => s.draftType, 'draftType', DocumentType.passport),
      ],
    );
  });

  group('DocumentFileCleared', () {
    blocTest<DocumentBloc, DocumentState>(
      'clears draftFile and activePickerSource',
      build: makeBloc,
      seed: () => DocumentState.loaded(
        documents: [],
        draftFile: draftFile,
        activePickerSource: FileSource.gallery,
      ),
      act: (bloc) => bloc.add(const DocumentFileCleared()),
      expect: () => [
        isA<DocumentLoaded>()
            .having((s) => s.draftFile, 'draftFile', isNull)
            .having((s) => s.activePickerSource, 'activePickerSource', isNull),
      ],
    );
  });

  group('DocumentDraftCleared', () {
    blocTest<DocumentBloc, DocumentState>(
      'clears all draft fields',
      build: makeBloc,
      seed: () => DocumentState.loaded(
        documents: [],
        draftType: DocumentType.passport,
        draftFile: draftFile,
        activePickerSource: FileSource.pdf,
      ),
      act: (bloc) => bloc.add(const DocumentDraftCleared()),
      expect: () => [
        isA<DocumentLoaded>()
            .having((s) => s.draftType, 'draftType', isNull)
            .having((s) => s.draftFile, 'draftFile', isNull)
            .having((s) => s.activePickerSource, 'activePickerSource', isNull),
      ],
    );
  });
}
