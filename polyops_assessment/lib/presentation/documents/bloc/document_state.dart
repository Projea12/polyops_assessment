import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/connectivity_status.dart';
import '../../../domain/entities/document_type.dart';
import '../../../domain/entities/file_source.dart';
import '../../../domain/entities/selected_file.dart';
import '../../../domain/entities/verification_document.dart';

part 'document_state.freezed.dart';

enum DocumentUploadStatus { idle, uploading, success, failure }

@freezed
sealed class DocumentState with _$DocumentState {
  const factory DocumentState.initial() = DocumentInitial;
  const factory DocumentState.loading() = DocumentLoading;

  const factory DocumentState.loaded({
    required List<VerificationDocument> documents,
    @Default(DocumentUploadStatus.idle) DocumentUploadStatus uploadStatus,
    @Default(ConnectivityStatus.offline) ConnectivityStatus connectivityStatus,
    VerificationDocument? lastUploaded,
    String? uploadError,
    DocumentType? draftType,
    SelectedFile? draftFile,
    FileSource? activePickerSource,
  }) = DocumentLoaded;

  const factory DocumentState.error(String message) = DocumentError;
}

extension DocumentLoadedX on DocumentLoaded {
  bool get canUpload => draftType != null && draftFile != null;
}
