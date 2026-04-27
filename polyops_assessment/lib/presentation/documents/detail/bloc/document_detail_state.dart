import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entities/document_audit_entry.dart';
import '../../../../domain/entities/verification_document.dart';

part 'document_detail_state.freezed.dart';

@freezed
sealed class DocumentDetailState with _$DocumentDetailState {
  const factory DocumentDetailState.initial() = DocumentDetailInitial;
  const factory DocumentDetailState.loading() = DocumentDetailLoading;

  const factory DocumentDetailState.loaded({
    required VerificationDocument document,
    required List<DocumentAuditEntry> auditTrail,
    @Default(false) bool isRetrying,
    String? retryError,
  }) = DocumentDetailLoaded;

  const factory DocumentDetailState.error(String message) = DocumentDetailError;
}
