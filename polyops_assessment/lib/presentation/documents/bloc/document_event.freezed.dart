// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentEvent()';
}


}

/// @nodoc
class $DocumentEventCopyWith<$Res>  {
$DocumentEventCopyWith(DocumentEvent _, $Res Function(DocumentEvent) __);
}


/// Adds pattern-matching-related methods to [DocumentEvent].
extension DocumentEventPatterns on DocumentEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DocumentSubscriptionRequested value)?  subscriptionRequested,TResult Function( DocumentUploadRequested value)?  uploadRequested,TResult Function( DocumentUploadStatusReset value)?  uploadStatusReset,TResult Function( DocumentTypeSelected value)?  typeSelected,TResult Function( DocumentPickFileRequested value)?  pickFileRequested,TResult Function( DocumentFileCleared value)?  fileCleared,TResult Function( DocumentDraftCleared value)?  draftCleared,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DocumentSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested(_that);case DocumentUploadRequested() when uploadRequested != null:
return uploadRequested(_that);case DocumentUploadStatusReset() when uploadStatusReset != null:
return uploadStatusReset(_that);case DocumentTypeSelected() when typeSelected != null:
return typeSelected(_that);case DocumentPickFileRequested() when pickFileRequested != null:
return pickFileRequested(_that);case DocumentFileCleared() when fileCleared != null:
return fileCleared(_that);case DocumentDraftCleared() when draftCleared != null:
return draftCleared(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DocumentSubscriptionRequested value)  subscriptionRequested,required TResult Function( DocumentUploadRequested value)  uploadRequested,required TResult Function( DocumentUploadStatusReset value)  uploadStatusReset,required TResult Function( DocumentTypeSelected value)  typeSelected,required TResult Function( DocumentPickFileRequested value)  pickFileRequested,required TResult Function( DocumentFileCleared value)  fileCleared,required TResult Function( DocumentDraftCleared value)  draftCleared,}){
final _that = this;
switch (_that) {
case DocumentSubscriptionRequested():
return subscriptionRequested(_that);case DocumentUploadRequested():
return uploadRequested(_that);case DocumentUploadStatusReset():
return uploadStatusReset(_that);case DocumentTypeSelected():
return typeSelected(_that);case DocumentPickFileRequested():
return pickFileRequested(_that);case DocumentFileCleared():
return fileCleared(_that);case DocumentDraftCleared():
return draftCleared(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DocumentSubscriptionRequested value)?  subscriptionRequested,TResult? Function( DocumentUploadRequested value)?  uploadRequested,TResult? Function( DocumentUploadStatusReset value)?  uploadStatusReset,TResult? Function( DocumentTypeSelected value)?  typeSelected,TResult? Function( DocumentPickFileRequested value)?  pickFileRequested,TResult? Function( DocumentFileCleared value)?  fileCleared,TResult? Function( DocumentDraftCleared value)?  draftCleared,}){
final _that = this;
switch (_that) {
case DocumentSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested(_that);case DocumentUploadRequested() when uploadRequested != null:
return uploadRequested(_that);case DocumentUploadStatusReset() when uploadStatusReset != null:
return uploadStatusReset(_that);case DocumentTypeSelected() when typeSelected != null:
return typeSelected(_that);case DocumentPickFileRequested() when pickFileRequested != null:
return pickFileRequested(_that);case DocumentFileCleared() when fileCleared != null:
return fileCleared(_that);case DocumentDraftCleared() when draftCleared != null:
return draftCleared(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  subscriptionRequested,TResult Function()?  uploadRequested,TResult Function()?  uploadStatusReset,TResult Function( DocumentType type)?  typeSelected,TResult Function( FileSource source)?  pickFileRequested,TResult Function()?  fileCleared,TResult Function()?  draftCleared,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DocumentSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested();case DocumentUploadRequested() when uploadRequested != null:
return uploadRequested();case DocumentUploadStatusReset() when uploadStatusReset != null:
return uploadStatusReset();case DocumentTypeSelected() when typeSelected != null:
return typeSelected(_that.type);case DocumentPickFileRequested() when pickFileRequested != null:
return pickFileRequested(_that.source);case DocumentFileCleared() when fileCleared != null:
return fileCleared();case DocumentDraftCleared() when draftCleared != null:
return draftCleared();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  subscriptionRequested,required TResult Function()  uploadRequested,required TResult Function()  uploadStatusReset,required TResult Function( DocumentType type)  typeSelected,required TResult Function( FileSource source)  pickFileRequested,required TResult Function()  fileCleared,required TResult Function()  draftCleared,}) {final _that = this;
switch (_that) {
case DocumentSubscriptionRequested():
return subscriptionRequested();case DocumentUploadRequested():
return uploadRequested();case DocumentUploadStatusReset():
return uploadStatusReset();case DocumentTypeSelected():
return typeSelected(_that.type);case DocumentPickFileRequested():
return pickFileRequested(_that.source);case DocumentFileCleared():
return fileCleared();case DocumentDraftCleared():
return draftCleared();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  subscriptionRequested,TResult? Function()?  uploadRequested,TResult? Function()?  uploadStatusReset,TResult? Function( DocumentType type)?  typeSelected,TResult? Function( FileSource source)?  pickFileRequested,TResult? Function()?  fileCleared,TResult? Function()?  draftCleared,}) {final _that = this;
switch (_that) {
case DocumentSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested();case DocumentUploadRequested() when uploadRequested != null:
return uploadRequested();case DocumentUploadStatusReset() when uploadStatusReset != null:
return uploadStatusReset();case DocumentTypeSelected() when typeSelected != null:
return typeSelected(_that.type);case DocumentPickFileRequested() when pickFileRequested != null:
return pickFileRequested(_that.source);case DocumentFileCleared() when fileCleared != null:
return fileCleared();case DocumentDraftCleared() when draftCleared != null:
return draftCleared();case _:
  return null;

}
}

}

/// @nodoc


class DocumentSubscriptionRequested implements DocumentEvent {
  const DocumentSubscriptionRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentSubscriptionRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentEvent.subscriptionRequested()';
}


}




/// @nodoc


class DocumentUploadRequested implements DocumentEvent {
  const DocumentUploadRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentUploadRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentEvent.uploadRequested()';
}


}




/// @nodoc


class DocumentUploadStatusReset implements DocumentEvent {
  const DocumentUploadStatusReset();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentUploadStatusReset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentEvent.uploadStatusReset()';
}


}




/// @nodoc


class DocumentTypeSelected implements DocumentEvent {
  const DocumentTypeSelected(this.type);
  

 final  DocumentType type;

/// Create a copy of DocumentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentTypeSelectedCopyWith<DocumentTypeSelected> get copyWith => _$DocumentTypeSelectedCopyWithImpl<DocumentTypeSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentTypeSelected&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'DocumentEvent.typeSelected(type: $type)';
}


}

/// @nodoc
abstract mixin class $DocumentTypeSelectedCopyWith<$Res> implements $DocumentEventCopyWith<$Res> {
  factory $DocumentTypeSelectedCopyWith(DocumentTypeSelected value, $Res Function(DocumentTypeSelected) _then) = _$DocumentTypeSelectedCopyWithImpl;
@useResult
$Res call({
 DocumentType type
});




}
/// @nodoc
class _$DocumentTypeSelectedCopyWithImpl<$Res>
    implements $DocumentTypeSelectedCopyWith<$Res> {
  _$DocumentTypeSelectedCopyWithImpl(this._self, this._then);

  final DocumentTypeSelected _self;
  final $Res Function(DocumentTypeSelected) _then;

/// Create a copy of DocumentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(DocumentTypeSelected(
null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,
  ));
}


}

/// @nodoc


class DocumentPickFileRequested implements DocumentEvent {
  const DocumentPickFileRequested(this.source);
  

 final  FileSource source;

/// Create a copy of DocumentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentPickFileRequestedCopyWith<DocumentPickFileRequested> get copyWith => _$DocumentPickFileRequestedCopyWithImpl<DocumentPickFileRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentPickFileRequested&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,source);

@override
String toString() {
  return 'DocumentEvent.pickFileRequested(source: $source)';
}


}

/// @nodoc
abstract mixin class $DocumentPickFileRequestedCopyWith<$Res> implements $DocumentEventCopyWith<$Res> {
  factory $DocumentPickFileRequestedCopyWith(DocumentPickFileRequested value, $Res Function(DocumentPickFileRequested) _then) = _$DocumentPickFileRequestedCopyWithImpl;
@useResult
$Res call({
 FileSource source
});




}
/// @nodoc
class _$DocumentPickFileRequestedCopyWithImpl<$Res>
    implements $DocumentPickFileRequestedCopyWith<$Res> {
  _$DocumentPickFileRequestedCopyWithImpl(this._self, this._then);

  final DocumentPickFileRequested _self;
  final $Res Function(DocumentPickFileRequested) _then;

/// Create a copy of DocumentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? source = null,}) {
  return _then(DocumentPickFileRequested(
null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as FileSource,
  ));
}


}

/// @nodoc


class DocumentFileCleared implements DocumentEvent {
  const DocumentFileCleared();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentFileCleared);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentEvent.fileCleared()';
}


}




/// @nodoc


class DocumentDraftCleared implements DocumentEvent {
  const DocumentDraftCleared();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentDraftCleared);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentEvent.draftCleared()';
}


}




// dart format on
