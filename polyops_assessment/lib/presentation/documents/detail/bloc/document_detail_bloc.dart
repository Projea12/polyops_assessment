import 'package:async/async.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/document_audit_entry.dart';
import '../../../../domain/entities/verification_document.dart';
import '../../../../domain/usecases/document/retry_verification_usecase.dart';
import '../../../../domain/usecases/document/watch_audit_trail_usecase.dart';
import '../../../../domain/usecases/document/watch_document_usecase.dart';
import 'document_detail_event.dart';
import 'document_detail_state.dart';

export 'document_detail_event.dart';
export 'document_detail_state.dart';

// Internal tagged union for merging the two reactive streams.
sealed class _DetailUpdate {}

final class _DocUpdate extends _DetailUpdate {
  final VerificationDocument doc;
  _DocUpdate(this.doc);
}

final class _AuditUpdate extends _DetailUpdate {
  final List<DocumentAuditEntry> trail;
  _AuditUpdate(this.trail);
}

@injectable
class DocumentDetailBloc
    extends Bloc<DocumentDetailEvent, DocumentDetailState> {
  final WatchDocumentUseCase _watchDocument;
  final WatchAuditTrailUseCase _watchAuditTrail;
  final RetryVerificationUseCase _retryVerification;

  DocumentDetailBloc(
    this._watchDocument,
    this._watchAuditTrail,
    this._retryVerification,
  ) : super(const DocumentDetailState.initial()) {
    on<DocumentDetailSubscriptionRequested>(
      _onSubscriptionRequested,
      transformer: restartable(),
    );
    on<DocumentDetailRetryRequested>(
      _onRetryRequested,
      transformer: droppable(),
    );
  }

  Future<void> _onSubscriptionRequested(
    DocumentDetailSubscriptionRequested event,
    Emitter<DocumentDetailState> emit,
  ) async {
    emit(const DocumentDetailState.loading());

    final merged = StreamGroup.merge([
      _watchDocument(event.documentId).map<_DetailUpdate>(_DocUpdate.new),
      _watchAuditTrail(event.documentId).map<_DetailUpdate>(_AuditUpdate.new),
    ]);

    await emit.forEach<_DetailUpdate>(
      merged,
      onData: (update) {
        final current = state;
        switch (update) {
          case _DocUpdate(:final doc):
            return DocumentDetailState.loaded(
              document: doc,
              auditTrail: current is DocumentDetailLoaded
                  ? current.auditTrail
                  : const [],
              isRetrying: current is DocumentDetailLoaded
                  ? current.isRetrying
                  : false,
            );
          case _AuditUpdate(:final trail):
            // Audit can arrive before the document stream emits — hold until loaded.
            if (current is! DocumentDetailLoaded) return current;
            return current.copyWith(auditTrail: trail);
        }
      },
      onError: (error, _) => DocumentDetailState.error(error.toString()),
    );
  }

  Future<void> _onRetryRequested(
    DocumentDetailRetryRequested event,
    Emitter<DocumentDetailState> emit,
  ) async {
    final current = state;
    if (current is! DocumentDetailLoaded) return;

    emit(current.copyWith(isRetrying: true, retryError: null));

    final result = await _retryVerification(event.documentId);
    result.fold(
      (failure) => emit(current.copyWith(
        isRetrying: false,
        retryError: failure.message,
      )),
      (_) => emit(current.copyWith(isRetrying: false)),
    );
  }
}
