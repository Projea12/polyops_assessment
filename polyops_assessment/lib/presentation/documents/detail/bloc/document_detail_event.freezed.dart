// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_detail_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentDetailEvent {

 String get documentId;
/// Create a copy of DocumentDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentDetailEventCopyWith<DocumentDetailEvent> get copyWith => _$DocumentDetailEventCopyWithImpl<DocumentDetailEvent>(this as DocumentDetailEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentDetailEvent&&(identical(other.documentId, documentId) || other.documentId == documentId));
}


@override
int get hashCode => Object.hash(runtimeType,documentId);

@override
String toString() {
  return 'DocumentDetailEvent(documentId: $documentId)';
}


}

/// @nodoc
abstract mixin class $DocumentDetailEventCopyWith<$Res>  {
  factory $DocumentDetailEventCopyWith(DocumentDetailEvent value, $Res Function(DocumentDetailEvent) _then) = _$DocumentDetailEventCopyWithImpl;
@useResult
$Res call({
 String documentId
});




}
/// @nodoc
class _$DocumentDetailEventCopyWithImpl<$Res>
    implements $DocumentDetailEventCopyWith<$Res> {
  _$DocumentDetailEventCopyWithImpl(this._self, this._then);

  final DocumentDetailEvent _self;
  final $Res Function(DocumentDetailEvent) _then;

/// Create a copy of DocumentDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentId = null,}) {
  return _then(_self.copyWith(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentDetailEvent].
extension DocumentDetailEventPatterns on DocumentDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DocumentDetailSubscriptionRequested value)?  subscriptionRequested,TResult Function( DocumentDetailRetryRequested value)?  retryRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DocumentDetailSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested(_that);case DocumentDetailRetryRequested() when retryRequested != null:
return retryRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DocumentDetailSubscriptionRequested value)  subscriptionRequested,required TResult Function( DocumentDetailRetryRequested value)  retryRequested,}){
final _that = this;
switch (_that) {
case DocumentDetailSubscriptionRequested():
return subscriptionRequested(_that);case DocumentDetailRetryRequested():
return retryRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DocumentDetailSubscriptionRequested value)?  subscriptionRequested,TResult? Function( DocumentDetailRetryRequested value)?  retryRequested,}){
final _that = this;
switch (_that) {
case DocumentDetailSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested(_that);case DocumentDetailRetryRequested() when retryRequested != null:
return retryRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String documentId)?  subscriptionRequested,TResult Function( String documentId)?  retryRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DocumentDetailSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested(_that.documentId);case DocumentDetailRetryRequested() when retryRequested != null:
return retryRequested(_that.documentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String documentId)  subscriptionRequested,required TResult Function( String documentId)  retryRequested,}) {final _that = this;
switch (_that) {
case DocumentDetailSubscriptionRequested():
return subscriptionRequested(_that.documentId);case DocumentDetailRetryRequested():
return retryRequested(_that.documentId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String documentId)?  subscriptionRequested,TResult? Function( String documentId)?  retryRequested,}) {final _that = this;
switch (_that) {
case DocumentDetailSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested(_that.documentId);case DocumentDetailRetryRequested() when retryRequested != null:
return retryRequested(_that.documentId);case _:
  return null;

}
}

}

/// @nodoc


class DocumentDetailSubscriptionRequested implements DocumentDetailEvent {
  const DocumentDetailSubscriptionRequested(this.documentId);
  

@override final  String documentId;

/// Create a copy of DocumentDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentDetailSubscriptionRequestedCopyWith<DocumentDetailSubscriptionRequested> get copyWith => _$DocumentDetailSubscriptionRequestedCopyWithImpl<DocumentDetailSubscriptionRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentDetailSubscriptionRequested&&(identical(other.documentId, documentId) || other.documentId == documentId));
}


@override
int get hashCode => Object.hash(runtimeType,documentId);

@override
String toString() {
  return 'DocumentDetailEvent.subscriptionRequested(documentId: $documentId)';
}


}

/// @nodoc
abstract mixin class $DocumentDetailSubscriptionRequestedCopyWith<$Res> implements $DocumentDetailEventCopyWith<$Res> {
  factory $DocumentDetailSubscriptionRequestedCopyWith(DocumentDetailSubscriptionRequested value, $Res Function(DocumentDetailSubscriptionRequested) _then) = _$DocumentDetailSubscriptionRequestedCopyWithImpl;
@override @useResult
$Res call({
 String documentId
});




}
/// @nodoc
class _$DocumentDetailSubscriptionRequestedCopyWithImpl<$Res>
    implements $DocumentDetailSubscriptionRequestedCopyWith<$Res> {
  _$DocumentDetailSubscriptionRequestedCopyWithImpl(this._self, this._then);

  final DocumentDetailSubscriptionRequested _self;
  final $Res Function(DocumentDetailSubscriptionRequested) _then;

/// Create a copy of DocumentDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentId = null,}) {
  return _then(DocumentDetailSubscriptionRequested(
null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DocumentDetailRetryRequested implements DocumentDetailEvent {
  const DocumentDetailRetryRequested(this.documentId);
  

@override final  String documentId;

/// Create a copy of DocumentDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentDetailRetryRequestedCopyWith<DocumentDetailRetryRequested> get copyWith => _$DocumentDetailRetryRequestedCopyWithImpl<DocumentDetailRetryRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentDetailRetryRequested&&(identical(other.documentId, documentId) || other.documentId == documentId));
}


@override
int get hashCode => Object.hash(runtimeType,documentId);

@override
String toString() {
  return 'DocumentDetailEvent.retryRequested(documentId: $documentId)';
}


}

/// @nodoc
abstract mixin class $DocumentDetailRetryRequestedCopyWith<$Res> implements $DocumentDetailEventCopyWith<$Res> {
  factory $DocumentDetailRetryRequestedCopyWith(DocumentDetailRetryRequested value, $Res Function(DocumentDetailRetryRequested) _then) = _$DocumentDetailRetryRequestedCopyWithImpl;
@override @useResult
$Res call({
 String documentId
});




}
/// @nodoc
class _$DocumentDetailRetryRequestedCopyWithImpl<$Res>
    implements $DocumentDetailRetryRequestedCopyWith<$Res> {
  _$DocumentDetailRetryRequestedCopyWithImpl(this._self, this._then);

  final DocumentDetailRetryRequested _self;
  final $Res Function(DocumentDetailRetryRequested) _then;

/// Create a copy of DocumentDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentId = null,}) {
  return _then(DocumentDetailRetryRequested(
null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
