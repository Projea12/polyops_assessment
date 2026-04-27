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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DocumentSubscriptionRequested value)?  subscriptionRequested,TResult Function( DocumentUploadRequested value)?  uploadRequested,TResult Function( DocumentUploadStatusReset value)?  uploadStatusReset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DocumentSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested(_that);case DocumentUploadRequested() when uploadRequested != null:
return uploadRequested(_that);case DocumentUploadStatusReset() when uploadStatusReset != null:
return uploadStatusReset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DocumentSubscriptionRequested value)  subscriptionRequested,required TResult Function( DocumentUploadRequested value)  uploadRequested,required TResult Function( DocumentUploadStatusReset value)  uploadStatusReset,}){
final _that = this;
switch (_that) {
case DocumentSubscriptionRequested():
return subscriptionRequested(_that);case DocumentUploadRequested():
return uploadRequested(_that);case DocumentUploadStatusReset():
return uploadStatusReset(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DocumentSubscriptionRequested value)?  subscriptionRequested,TResult? Function( DocumentUploadRequested value)?  uploadRequested,TResult? Function( DocumentUploadStatusReset value)?  uploadStatusReset,}){
final _that = this;
switch (_that) {
case DocumentSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested(_that);case DocumentUploadRequested() when uploadRequested != null:
return uploadRequested(_that);case DocumentUploadStatusReset() when uploadStatusReset != null:
return uploadStatusReset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  subscriptionRequested,TResult Function( String filePath,  DocumentType type)?  uploadRequested,TResult Function()?  uploadStatusReset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DocumentSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested();case DocumentUploadRequested() when uploadRequested != null:
return uploadRequested(_that.filePath,_that.type);case DocumentUploadStatusReset() when uploadStatusReset != null:
return uploadStatusReset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  subscriptionRequested,required TResult Function( String filePath,  DocumentType type)  uploadRequested,required TResult Function()  uploadStatusReset,}) {final _that = this;
switch (_that) {
case DocumentSubscriptionRequested():
return subscriptionRequested();case DocumentUploadRequested():
return uploadRequested(_that.filePath,_that.type);case DocumentUploadStatusReset():
return uploadStatusReset();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  subscriptionRequested,TResult? Function( String filePath,  DocumentType type)?  uploadRequested,TResult? Function()?  uploadStatusReset,}) {final _that = this;
switch (_that) {
case DocumentSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested();case DocumentUploadRequested() when uploadRequested != null:
return uploadRequested(_that.filePath,_that.type);case DocumentUploadStatusReset() when uploadStatusReset != null:
return uploadStatusReset();case _:
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
  const DocumentUploadRequested({required this.filePath, required this.type});
  

 final  String filePath;
 final  DocumentType type;

/// Create a copy of DocumentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentUploadRequestedCopyWith<DocumentUploadRequested> get copyWith => _$DocumentUploadRequestedCopyWithImpl<DocumentUploadRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentUploadRequested&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,filePath,type);

@override
String toString() {
  return 'DocumentEvent.uploadRequested(filePath: $filePath, type: $type)';
}


}

/// @nodoc
abstract mixin class $DocumentUploadRequestedCopyWith<$Res> implements $DocumentEventCopyWith<$Res> {
  factory $DocumentUploadRequestedCopyWith(DocumentUploadRequested value, $Res Function(DocumentUploadRequested) _then) = _$DocumentUploadRequestedCopyWithImpl;
@useResult
$Res call({
 String filePath, DocumentType type
});




}
/// @nodoc
class _$DocumentUploadRequestedCopyWithImpl<$Res>
    implements $DocumentUploadRequestedCopyWith<$Res> {
  _$DocumentUploadRequestedCopyWithImpl(this._self, this._then);

  final DocumentUploadRequested _self;
  final $Res Function(DocumentUploadRequested) _then;

/// Create a copy of DocumentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filePath = null,Object? type = null,}) {
  return _then(DocumentUploadRequested(
filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,
  ));
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




// dart format on
