import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/document_type.dart';

part 'document_event.freezed.dart';

@freezed
sealed class DocumentEvent with _$DocumentEvent {
  const factory DocumentEvent.subscriptionRequested() =
      DocumentSubscriptionRequested;

  const factory DocumentEvent.uploadRequested({
    required String filePath,
    required DocumentType type,
  }) = DocumentUploadRequested;

  /// Resets upload status back to idle after the UI has consumed the result.
  const factory DocumentEvent.uploadStatusReset() = DocumentUploadStatusReset;
}
