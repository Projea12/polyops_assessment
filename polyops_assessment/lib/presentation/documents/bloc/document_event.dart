import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/document_type.dart';
import '../../../domain/entities/file_source.dart';

part 'document_event.freezed.dart';

@freezed
sealed class DocumentEvent with _$DocumentEvent {
  const factory DocumentEvent.subscriptionRequested() =
      DocumentSubscriptionRequested;

  /// BLoC reads filePath + type from its own draft state.
  const factory DocumentEvent.uploadRequested() = DocumentUploadRequested;

  const factory DocumentEvent.uploadStatusReset() = DocumentUploadStatusReset;

  const factory DocumentEvent.typeSelected(DocumentType type) =
      DocumentTypeSelected;

  const factory DocumentEvent.pickFileRequested(FileSource source) =
      DocumentPickFileRequested;

  const factory DocumentEvent.fileCleared() = DocumentFileCleared;

  /// Dispatched when the upload sheet is dismissed (cancel or success).
  const factory DocumentEvent.draftCleared() = DocumentDraftCleared;
}
