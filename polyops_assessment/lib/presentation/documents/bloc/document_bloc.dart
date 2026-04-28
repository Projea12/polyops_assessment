import 'package:async/async.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/connectivity_status.dart';
import '../../../domain/entities/verification_document.dart';
import '../../../domain/repositories/i_document_repository.dart';
import '../../../domain/usecases/document/pick_document_file_usecase.dart';
import '../../../domain/usecases/document/upload_document_usecase.dart';
import '../../../domain/usecases/document/watch_document_usecase.dart';
import 'document_event.dart';
import 'document_state.dart';

export 'document_event.dart';
export 'document_state.dart';

// Internal tagged union for merging document list and connectivity streams.
sealed class _DashboardUpdate {}

final class _DocsUpdate extends _DashboardUpdate {
  final List<VerificationDocument> docs;
  _DocsUpdate(this.docs);
}

final class _ConnUpdate extends _DashboardUpdate {
  final ConnectivityStatus status;
  _ConnUpdate(this.status);
}

@injectable
class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final WatchDocumentUseCase _watchDocuments;
  final UploadDocumentUseCase _uploadDocument;
  final IDocumentRepository _documentRepository;
  final PickDocumentFileUseCase _pickDocumentFile;

  DocumentBloc(
    this._watchDocuments,
    this._uploadDocument,
    this._documentRepository,
    this._pickDocumentFile,
  ) : super(const DocumentState.initial()) {
    on<DocumentSubscriptionRequested>(
      _onSubscriptionRequested,
      transformer: restartable(),
    );
    on<DocumentUploadRequested>(
      _onUploadRequested,
      transformer: sequential(),
    );
    on<DocumentUploadStatusReset>(_onUploadStatusReset);
    on<DocumentTypeSelected>(_onTypeSelected, transformer: droppable());
    on<DocumentPickFileRequested>(_onPickFileRequested, transformer: droppable());
    on<DocumentFileCleared>(_onFileCleared, transformer: droppable());
    on<DocumentDraftCleared>(_onDraftCleared, transformer: droppable());
  }

  Future<void> _onSubscriptionRequested(
    DocumentSubscriptionRequested event,
    Emitter<DocumentState> emit,
  ) async {
    // Capture draft before transitioning to loading so it survives the gap.
    final prevLoaded = state is DocumentLoaded ? state as DocumentLoaded : null;

    emit(const DocumentState.loading());

    var currentConnStatus = _documentRepository.connectivityStatus;

    final merged = StreamGroup.merge([
      _watchDocuments.watchAll().map<_DashboardUpdate>(_DocsUpdate.new),
      _documentRepository
          .watchConnectivityStatus()
          .map<_DashboardUpdate>(_ConnUpdate.new),
    ]);

    await emit.forEach<_DashboardUpdate>(
      merged,
      onData: (update) {
        final current = state;
        // After the first _DocsUpdate the state is DocumentLoaded; use it.
        // On the very first emission state is still DocumentLoading, so fall
        // back to prevLoaded to recover connectivity + draft.
        final ref = current is DocumentLoaded ? current : prevLoaded;
        switch (update) {
          case _DocsUpdate(:final docs):
            return DocumentState.loaded(
              documents: docs,
              connectivityStatus: ref?.connectivityStatus ?? currentConnStatus,
              uploadStatus: ref?.uploadStatus ?? DocumentUploadStatus.idle,
              lastUploaded: ref?.lastUploaded,
              uploadError: ref?.uploadError,
              draftType: ref?.draftType,
              draftFile: ref?.draftFile,
              activePickerSource: ref?.activePickerSource,
            );
          case _ConnUpdate(:final status):
            currentConnStatus = status;
            if (current is! DocumentLoaded) return current;
            return current.copyWith(connectivityStatus: status);
        }
      },
      onError: (error, _) => DocumentState.error(error.toString()),
    );
  }

  Future<void> _onUploadRequested(
    DocumentUploadRequested event,
    Emitter<DocumentState> emit,
  ) async {
    final current = state;
    if (current is! DocumentLoaded) return;
    if (!current.canUpload) return;

    emit(current.copyWith(
      uploadStatus: DocumentUploadStatus.uploading,
      uploadError: null,
    ));

    final result = await _uploadDocument(
      filePath: current.draftFile!.path,
      type: current.draftType!,
    );

    result.fold(
      (failure) => emit(current.copyWith(
        uploadStatus: DocumentUploadStatus.failure,
        uploadError: failure.message,
      )),
      (document) => emit(current.copyWith(
        uploadStatus: DocumentUploadStatus.success,
        lastUploaded: document,
        draftType: null,
        draftFile: null,
        activePickerSource: null,
      )),
    );
  }

  void _onUploadStatusReset(
    DocumentUploadStatusReset event,
    Emitter<DocumentState> emit,
  ) {
    final current = state;
    if (current is! DocumentLoaded) return;
    emit(current.copyWith(
      uploadStatus: DocumentUploadStatus.idle,
      uploadError: null,
      lastUploaded: null,
    ));
  }

  void _onTypeSelected(
    DocumentTypeSelected event,
    Emitter<DocumentState> emit,
  ) {
    final current = state;
    if (current is! DocumentLoaded) return;
    emit(current.copyWith(draftType: event.type));
  }

  Future<void> _onPickFileRequested(
    DocumentPickFileRequested event,
    Emitter<DocumentState> emit,
  ) async {
    final current = state;
    if (current is! DocumentLoaded) return;

    emit(current.copyWith(activePickerSource: event.source));

    final result = await _pickDocumentFile(event.source);

    result.fold(
      (_) => emit(current.copyWith(activePickerSource: null)),
      (file) => emit(current.copyWith(
        draftFile: file,
        activePickerSource: null,
      )),
    );
  }

  void _onFileCleared(
    DocumentFileCleared event,
    Emitter<DocumentState> emit,
  ) {
    final current = state;
    if (current is! DocumentLoaded) return;
    emit(current.copyWith(
      draftFile: null,
      activePickerSource: null,
    ));
  }

  void _onDraftCleared(
    DocumentDraftCleared event,
    Emitter<DocumentState> emit,
  ) {
    final current = state;
    if (current is! DocumentLoaded) return;
    emit(current.copyWith(
      draftType: null,
      draftFile: null,
      activePickerSource: null,
    ));
  }
}
