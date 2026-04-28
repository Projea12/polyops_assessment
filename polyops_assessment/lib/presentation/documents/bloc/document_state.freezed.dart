// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentState()';
}


}

/// @nodoc
class $DocumentStateCopyWith<$Res>  {
$DocumentStateCopyWith(DocumentState _, $Res Function(DocumentState) __);
}


/// Adds pattern-matching-related methods to [DocumentState].
extension DocumentStatePatterns on DocumentState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DocumentInitial value)?  initial,TResult Function( DocumentLoading value)?  loading,TResult Function( DocumentLoaded value)?  loaded,TResult Function( DocumentError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DocumentInitial() when initial != null:
return initial(_that);case DocumentLoading() when loading != null:
return loading(_that);case DocumentLoaded() when loaded != null:
return loaded(_that);case DocumentError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DocumentInitial value)  initial,required TResult Function( DocumentLoading value)  loading,required TResult Function( DocumentLoaded value)  loaded,required TResult Function( DocumentError value)  error,}){
final _that = this;
switch (_that) {
case DocumentInitial():
return initial(_that);case DocumentLoading():
return loading(_that);case DocumentLoaded():
return loaded(_that);case DocumentError():
return error(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DocumentInitial value)?  initial,TResult? Function( DocumentLoading value)?  loading,TResult? Function( DocumentLoaded value)?  loaded,TResult? Function( DocumentError value)?  error,}){
final _that = this;
switch (_that) {
case DocumentInitial() when initial != null:
return initial(_that);case DocumentLoading() when loading != null:
return loading(_that);case DocumentLoaded() when loaded != null:
return loaded(_that);case DocumentError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<VerificationDocument> documents,  DocumentUploadStatus uploadStatus,  ConnectivityStatus connectivityStatus,  VerificationDocument? lastUploaded,  String? uploadError,  DocumentType? draftType,  SelectedFile? draftFile,  FileSource? activePickerSource)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DocumentInitial() when initial != null:
return initial();case DocumentLoading() when loading != null:
return loading();case DocumentLoaded() when loaded != null:
return loaded(_that.documents,_that.uploadStatus,_that.connectivityStatus,_that.lastUploaded,_that.uploadError,_that.draftType,_that.draftFile,_that.activePickerSource);case DocumentError() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<VerificationDocument> documents,  DocumentUploadStatus uploadStatus,  ConnectivityStatus connectivityStatus,  VerificationDocument? lastUploaded,  String? uploadError,  DocumentType? draftType,  SelectedFile? draftFile,  FileSource? activePickerSource)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case DocumentInitial():
return initial();case DocumentLoading():
return loading();case DocumentLoaded():
return loaded(_that.documents,_that.uploadStatus,_that.connectivityStatus,_that.lastUploaded,_that.uploadError,_that.draftType,_that.draftFile,_that.activePickerSource);case DocumentError():
return error(_that.message);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<VerificationDocument> documents,  DocumentUploadStatus uploadStatus,  ConnectivityStatus connectivityStatus,  VerificationDocument? lastUploaded,  String? uploadError,  DocumentType? draftType,  SelectedFile? draftFile,  FileSource? activePickerSource)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case DocumentInitial() when initial != null:
return initial();case DocumentLoading() when loading != null:
return loading();case DocumentLoaded() when loaded != null:
return loaded(_that.documents,_that.uploadStatus,_that.connectivityStatus,_that.lastUploaded,_that.uploadError,_that.draftType,_that.draftFile,_that.activePickerSource);case DocumentError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class DocumentInitial implements DocumentState {
  const DocumentInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentState.initial()';
}


}




/// @nodoc


class DocumentLoading implements DocumentState {
  const DocumentLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentState.loading()';
}


}




/// @nodoc


class DocumentLoaded implements DocumentState {
  const DocumentLoaded({required final  List<VerificationDocument> documents, this.uploadStatus = DocumentUploadStatus.idle, this.connectivityStatus = ConnectivityStatus.offline, this.lastUploaded, this.uploadError, this.draftType, this.draftFile, this.activePickerSource}): _documents = documents;
  

 final  List<VerificationDocument> _documents;
 List<VerificationDocument> get documents {
  if (_documents is EqualUnmodifiableListView) return _documents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_documents);
}

@JsonKey() final  DocumentUploadStatus uploadStatus;
@JsonKey() final  ConnectivityStatus connectivityStatus;
 final  VerificationDocument? lastUploaded;
 final  String? uploadError;
 final  DocumentType? draftType;
 final  SelectedFile? draftFile;
 final  FileSource? activePickerSource;

/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentLoadedCopyWith<DocumentLoaded> get copyWith => _$DocumentLoadedCopyWithImpl<DocumentLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentLoaded&&const DeepCollectionEquality().equals(other._documents, _documents)&&(identical(other.uploadStatus, uploadStatus) || other.uploadStatus == uploadStatus)&&(identical(other.connectivityStatus, connectivityStatus) || other.connectivityStatus == connectivityStatus)&&(identical(other.lastUploaded, lastUploaded) || other.lastUploaded == lastUploaded)&&(identical(other.uploadError, uploadError) || other.uploadError == uploadError)&&(identical(other.draftType, draftType) || other.draftType == draftType)&&(identical(other.draftFile, draftFile) || other.draftFile == draftFile)&&(identical(other.activePickerSource, activePickerSource) || other.activePickerSource == activePickerSource));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_documents),uploadStatus,connectivityStatus,lastUploaded,uploadError,draftType,draftFile,activePickerSource);

@override
String toString() {
  return 'DocumentState.loaded(documents: $documents, uploadStatus: $uploadStatus, connectivityStatus: $connectivityStatus, lastUploaded: $lastUploaded, uploadError: $uploadError, draftType: $draftType, draftFile: $draftFile, activePickerSource: $activePickerSource)';
}


}

/// @nodoc
abstract mixin class $DocumentLoadedCopyWith<$Res> implements $DocumentStateCopyWith<$Res> {
  factory $DocumentLoadedCopyWith(DocumentLoaded value, $Res Function(DocumentLoaded) _then) = _$DocumentLoadedCopyWithImpl;
@useResult
$Res call({
 List<VerificationDocument> documents, DocumentUploadStatus uploadStatus, ConnectivityStatus connectivityStatus, VerificationDocument? lastUploaded, String? uploadError, DocumentType? draftType, SelectedFile? draftFile, FileSource? activePickerSource
});




}
/// @nodoc
class _$DocumentLoadedCopyWithImpl<$Res>
    implements $DocumentLoadedCopyWith<$Res> {
  _$DocumentLoadedCopyWithImpl(this._self, this._then);

  final DocumentLoaded _self;
  final $Res Function(DocumentLoaded) _then;

/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? documents = null,Object? uploadStatus = null,Object? connectivityStatus = null,Object? lastUploaded = freezed,Object? uploadError = freezed,Object? draftType = freezed,Object? draftFile = freezed,Object? activePickerSource = freezed,}) {
  return _then(DocumentLoaded(
documents: null == documents ? _self._documents : documents // ignore: cast_nullable_to_non_nullable
as List<VerificationDocument>,uploadStatus: null == uploadStatus ? _self.uploadStatus : uploadStatus // ignore: cast_nullable_to_non_nullable
as DocumentUploadStatus,connectivityStatus: null == connectivityStatus ? _self.connectivityStatus : connectivityStatus // ignore: cast_nullable_to_non_nullable
as ConnectivityStatus,lastUploaded: freezed == lastUploaded ? _self.lastUploaded : lastUploaded // ignore: cast_nullable_to_non_nullable
as VerificationDocument?,uploadError: freezed == uploadError ? _self.uploadError : uploadError // ignore: cast_nullable_to_non_nullable
as String?,draftType: freezed == draftType ? _self.draftType : draftType // ignore: cast_nullable_to_non_nullable
as DocumentType?,draftFile: freezed == draftFile ? _self.draftFile : draftFile // ignore: cast_nullable_to_non_nullable
as SelectedFile?,activePickerSource: freezed == activePickerSource ? _self.activePickerSource : activePickerSource // ignore: cast_nullable_to_non_nullable
as FileSource?,
  ));
}


}

/// @nodoc


class DocumentError implements DocumentState {
  const DocumentError(this.message);
  

 final  String message;

/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentErrorCopyWith<DocumentError> get copyWith => _$DocumentErrorCopyWithImpl<DocumentError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DocumentState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $DocumentErrorCopyWith<$Res> implements $DocumentStateCopyWith<$Res> {
  factory $DocumentErrorCopyWith(DocumentError value, $Res Function(DocumentError) _then) = _$DocumentErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DocumentErrorCopyWithImpl<$Res>
    implements $DocumentErrorCopyWith<$Res> {
  _$DocumentErrorCopyWithImpl(this._self, this._then);

  final DocumentError _self;
  final $Res Function(DocumentError) _then;

/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DocumentError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
