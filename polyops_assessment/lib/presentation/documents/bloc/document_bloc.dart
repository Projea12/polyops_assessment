import 'package:async/async.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/connectivity_status.dart';
import '../../../domain/entities/verification_document.dart';
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

  DocumentBloc(this._watchDocuments, this._uploadDocument)
      : super(const DocumentState.initial()) {
    on<DocumentSubscriptionRequested>(
      _onSubscriptionRequested,
      transformer: restartable(),
    );
    on<DocumentUploadRequested>(
      _onUploadRequested,
      transformer: sequential(),
    );
    on<DocumentUploadStatusReset>(_onUploadStatusReset);
  }

  Future<void> _onSubscriptionRequested(
    DocumentSubscriptionRequested event,
    Emitter<DocumentState> emit,
  ) async {
    emit(const DocumentState.loading());

    // Seed from the repository's current value so connectivity is correct even
    // before the first stream emission arrives.
    var currentConnStatus = _watchDocuments.connectivityStatus;

    final merged = StreamGroup.merge([
      _watchDocuments.watchAll().map<_DashboardUpdate>(_DocsUpdate.new),
      _watchDocuments
          .watchConnectivityStatus()
          .map<_DashboardUpdate>(_ConnUpdate.new),
    ]);

    await emit.forEach<_DashboardUpdate>(
      merged,
      onData: (update) {
        final current = state;
        switch (update) {
          case _DocsUpdate(:final docs):
            return DocumentState.loaded(
              documents: docs,
              connectivityStatus: current is DocumentLoaded
                  ? current.connectivityStatus
                  : currentConnStatus,
              uploadStatus: current is DocumentLoaded
                  ? current.uploadStatus
                  : DocumentUploadStatus.idle,
              lastUploaded:
                  current is DocumentLoaded ? current.lastUploaded : null,
              uploadError:
                  current is DocumentLoaded ? current.uploadError : null,
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

    emit(current.copyWith(
      uploadStatus: DocumentUploadStatus.uploading,
      uploadError: null,
    ));

    final result = await _uploadDocument(
      filePath: event.filePath,
      type: event.type,
    );

    result.fold(
      (failure) => emit(current.copyWith(
        uploadStatus: DocumentUploadStatus.failure,
        uploadError: failure.message,
      )),
      (document) => emit(current.copyWith(
        uploadStatus: DocumentUploadStatus.success,
        lastUploaded: document,
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
}
