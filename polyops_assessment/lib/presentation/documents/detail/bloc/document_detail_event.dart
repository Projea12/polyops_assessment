import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_detail_event.freezed.dart';

@freezed
sealed class DocumentDetailEvent with _$DocumentDetailEvent {
  const factory DocumentDetailEvent.subscriptionRequested(
    String documentId,
  ) = DocumentDetailSubscriptionRequested;

  const factory DocumentDetailEvent.retryRequested(
    String documentId,
  ) = DocumentDetailRetryRequested;
}
