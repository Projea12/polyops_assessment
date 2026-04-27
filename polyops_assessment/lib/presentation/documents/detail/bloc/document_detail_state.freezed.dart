// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentDetailState()';
}


}

/// @nodoc
class $DocumentDetailStateCopyWith<$Res>  {
$DocumentDetailStateCopyWith(DocumentDetailState _, $Res Function(DocumentDetailState) __);
}


/// Adds pattern-matching-related methods to [DocumentDetailState].
extension DocumentDetailStatePatterns on DocumentDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DocumentDetailInitial value)?  initial,TResult Function( DocumentDetailLoading value)?  loading,TResult Function( DocumentDetailLoaded value)?  loaded,TResult Function( DocumentDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DocumentDetailInitial() when initial != null:
return initial(_that);case DocumentDetailLoading() when loading != null:
return loading(_that);case DocumentDetailLoaded() when loaded != null:
return loaded(_that);case DocumentDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DocumentDetailInitial value)  initial,required TResult Function( DocumentDetailLoading value)  loading,required TResult Function( DocumentDetailLoaded value)  loaded,required TResult Function( DocumentDetailError value)  error,}){
final _that = this;
switch (_that) {
case DocumentDetailInitial():
return initial(_that);case DocumentDetailLoading():
return loading(_that);case DocumentDetailLoaded():
return loaded(_that);case DocumentDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DocumentDetailInitial value)?  initial,TResult? Function( DocumentDetailLoading value)?  loading,TResult? Function( DocumentDetailLoaded value)?  loaded,TResult? Function( DocumentDetailError value)?  error,}){
final _that = this;
switch (_that) {
case DocumentDetailInitial() when initial != null:
return initial(_that);case DocumentDetailLoading() when loading != null:
return loading(_that);case DocumentDetailLoaded() when loaded != null:
return loaded(_that);case DocumentDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( VerificationDocument document,  List<DocumentAuditEntry> auditTrail,  bool isRetrying,  String? retryError)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DocumentDetailInitial() when initial != null:
return initial();case DocumentDetailLoading() when loading != null:
return loading();case DocumentDetailLoaded() when loaded != null:
return loaded(_that.document,_that.auditTrail,_that.isRetrying,_that.retryError);case DocumentDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( VerificationDocument document,  List<DocumentAuditEntry> auditTrail,  bool isRetrying,  String? retryError)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case DocumentDetailInitial():
return initial();case DocumentDetailLoading():
return loading();case DocumentDetailLoaded():
return loaded(_that.document,_that.auditTrail,_that.isRetrying,_that.retryError);case DocumentDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( VerificationDocument document,  List<DocumentAuditEntry> auditTrail,  bool isRetrying,  String? retryError)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case DocumentDetailInitial() when initial != null:
return initial();case DocumentDetailLoading() when loading != null:
return loading();case DocumentDetailLoaded() when loaded != null:
return loaded(_that.document,_that.auditTrail,_that.isRetrying,_that.retryError);case DocumentDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class DocumentDetailInitial implements DocumentDetailState {
  const DocumentDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentDetailState.initial()';
}


}




/// @nodoc


class DocumentDetailLoading implements DocumentDetailState {
  const DocumentDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentDetailState.loading()';
}


}




/// @nodoc


class DocumentDetailLoaded implements DocumentDetailState {
  const DocumentDetailLoaded({required this.document, required final  List<DocumentAuditEntry> auditTrail, this.isRetrying = false, this.retryError}): _auditTrail = auditTrail;
  

 final  VerificationDocument document;
 final  List<DocumentAuditEntry> _auditTrail;
 List<DocumentAuditEntry> get auditTrail {
  if (_auditTrail is EqualUnmodifiableListView) return _auditTrail;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_auditTrail);
}

@JsonKey() final  bool isRetrying;
 final  String? retryError;

/// Create a copy of DocumentDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentDetailLoadedCopyWith<DocumentDetailLoaded> get copyWith => _$DocumentDetailLoadedCopyWithImpl<DocumentDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentDetailLoaded&&(identical(other.document, document) || other.document == document)&&const DeepCollectionEquality().equals(other._auditTrail, _auditTrail)&&(identical(other.isRetrying, isRetrying) || other.isRetrying == isRetrying)&&(identical(other.retryError, retryError) || other.retryError == retryError));
}


@override
int get hashCode => Object.hash(runtimeType,document,const DeepCollectionEquality().hash(_auditTrail),isRetrying,retryError);

@override
String toString() {
  return 'DocumentDetailState.loaded(document: $document, auditTrail: $auditTrail, isRetrying: $isRetrying, retryError: $retryError)';
}


}

/// @nodoc
abstract mixin class $DocumentDetailLoadedCopyWith<$Res> implements $DocumentDetailStateCopyWith<$Res> {
  factory $DocumentDetailLoadedCopyWith(DocumentDetailLoaded value, $Res Function(DocumentDetailLoaded) _then) = _$DocumentDetailLoadedCopyWithImpl;
@useResult
$Res call({
 VerificationDocument document, List<DocumentAuditEntry> auditTrail, bool isRetrying, String? retryError
});




}
/// @nodoc
class _$DocumentDetailLoadedCopyWithImpl<$Res>
    implements $DocumentDetailLoadedCopyWith<$Res> {
  _$DocumentDetailLoadedCopyWithImpl(this._self, this._then);

  final DocumentDetailLoaded _self;
  final $Res Function(DocumentDetailLoaded) _then;

/// Create a copy of DocumentDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? document = null,Object? auditTrail = null,Object? isRetrying = null,Object? retryError = freezed,}) {
  return _then(DocumentDetailLoaded(
document: null == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as VerificationDocument,auditTrail: null == auditTrail ? _self._auditTrail : auditTrail // ignore: cast_nullable_to_non_nullable
as List<DocumentAuditEntry>,isRetrying: null == isRetrying ? _self.isRetrying : isRetrying // ignore: cast_nullable_to_non_nullable
as bool,retryError: freezed == retryError ? _self.retryError : retryError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class DocumentDetailError implements DocumentDetailState {
  const DocumentDetailError(this.message);
  

 final  String message;

/// Create a copy of DocumentDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentDetailErrorCopyWith<DocumentDetailError> get copyWith => _$DocumentDetailErrorCopyWithImpl<DocumentDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DocumentDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $DocumentDetailErrorCopyWith<$Res> implements $DocumentDetailStateCopyWith<$Res> {
  factory $DocumentDetailErrorCopyWith(DocumentDetailError value, $Res Function(DocumentDetailError) _then) = _$DocumentDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DocumentDetailErrorCopyWithImpl<$Res>
    implements $DocumentDetailErrorCopyWith<$Res> {
  _$DocumentDetailErrorCopyWithImpl(this._self, this._then);

  final DocumentDetailError _self;
  final $Res Function(DocumentDetailError) _then;

/// Create a copy of DocumentDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DocumentDetailError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
