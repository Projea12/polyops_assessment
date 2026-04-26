// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoardState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BoardState()';
}


}

/// @nodoc
class $BoardStateCopyWith<$Res>  {
$BoardStateCopyWith(BoardState _, $Res Function(BoardState) __);
}


/// Adds pattern-matching-related methods to [BoardState].
extension BoardStatePatterns on BoardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BoardInitial value)?  initial,TResult Function( BoardLoading value)?  loading,TResult Function( BoardLoaded value)?  loaded,TResult Function( BoardError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BoardInitial() when initial != null:
return initial(_that);case BoardLoading() when loading != null:
return loading(_that);case BoardLoaded() when loaded != null:
return loaded(_that);case BoardError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BoardInitial value)  initial,required TResult Function( BoardLoading value)  loading,required TResult Function( BoardLoaded value)  loaded,required TResult Function( BoardError value)  error,}){
final _that = this;
switch (_that) {
case BoardInitial():
return initial(_that);case BoardLoading():
return loading(_that);case BoardLoaded():
return loaded(_that);case BoardError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BoardInitial value)?  initial,TResult? Function( BoardLoading value)?  loading,TResult? Function( BoardLoaded value)?  loaded,TResult? Function( BoardError value)?  error,}){
final _that = this;
switch (_that) {
case BoardInitial() when initial != null:
return initial(_that);case BoardLoading() when loading != null:
return loading(_that);case BoardLoaded() when loaded != null:
return loaded(_that);case BoardError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Map<TaskStatus, List<BoardTask>> columns,  String? draggingTaskId,  TaskStatus? dragOverColumn)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BoardInitial() when initial != null:
return initial();case BoardLoading() when loading != null:
return loading();case BoardLoaded() when loaded != null:
return loaded(_that.columns,_that.draggingTaskId,_that.dragOverColumn);case BoardError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Map<TaskStatus, List<BoardTask>> columns,  String? draggingTaskId,  TaskStatus? dragOverColumn)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case BoardInitial():
return initial();case BoardLoading():
return loading();case BoardLoaded():
return loaded(_that.columns,_that.draggingTaskId,_that.dragOverColumn);case BoardError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Map<TaskStatus, List<BoardTask>> columns,  String? draggingTaskId,  TaskStatus? dragOverColumn)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case BoardInitial() when initial != null:
return initial();case BoardLoading() when loading != null:
return loading();case BoardLoaded() when loaded != null:
return loaded(_that.columns,_that.draggingTaskId,_that.dragOverColumn);case BoardError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class BoardInitial implements BoardState {
  const BoardInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BoardState.initial()';
}


}




/// @nodoc


class BoardLoading implements BoardState {
  const BoardLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BoardState.loading()';
}


}




/// @nodoc


class BoardLoaded implements BoardState {
  const BoardLoaded({required final  Map<TaskStatus, List<BoardTask>> columns, this.draggingTaskId, this.dragOverColumn}): _columns = columns;
  

 final  Map<TaskStatus, List<BoardTask>> _columns;
 Map<TaskStatus, List<BoardTask>> get columns {
  if (_columns is EqualUnmodifiableMapView) return _columns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_columns);
}

 final  String? draggingTaskId;
 final  TaskStatus? dragOverColumn;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardLoadedCopyWith<BoardLoaded> get copyWith => _$BoardLoadedCopyWithImpl<BoardLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardLoaded&&const DeepCollectionEquality().equals(other._columns, _columns)&&(identical(other.draggingTaskId, draggingTaskId) || other.draggingTaskId == draggingTaskId)&&(identical(other.dragOverColumn, dragOverColumn) || other.dragOverColumn == dragOverColumn));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_columns),draggingTaskId,dragOverColumn);

@override
String toString() {
  return 'BoardState.loaded(columns: $columns, draggingTaskId: $draggingTaskId, dragOverColumn: $dragOverColumn)';
}


}

/// @nodoc
abstract mixin class $BoardLoadedCopyWith<$Res> implements $BoardStateCopyWith<$Res> {
  factory $BoardLoadedCopyWith(BoardLoaded value, $Res Function(BoardLoaded) _then) = _$BoardLoadedCopyWithImpl;
@useResult
$Res call({
 Map<TaskStatus, List<BoardTask>> columns, String? draggingTaskId, TaskStatus? dragOverColumn
});




}
/// @nodoc
class _$BoardLoadedCopyWithImpl<$Res>
    implements $BoardLoadedCopyWith<$Res> {
  _$BoardLoadedCopyWithImpl(this._self, this._then);

  final BoardLoaded _self;
  final $Res Function(BoardLoaded) _then;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? columns = null,Object? draggingTaskId = freezed,Object? dragOverColumn = freezed,}) {
  return _then(BoardLoaded(
columns: null == columns ? _self._columns : columns // ignore: cast_nullable_to_non_nullable
as Map<TaskStatus, List<BoardTask>>,draggingTaskId: freezed == draggingTaskId ? _self.draggingTaskId : draggingTaskId // ignore: cast_nullable_to_non_nullable
as String?,dragOverColumn: freezed == dragOverColumn ? _self.dragOverColumn : dragOverColumn // ignore: cast_nullable_to_non_nullable
as TaskStatus?,
  ));
}


}

/// @nodoc


class BoardError implements BoardState {
  const BoardError(this.message);
  

 final  String message;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardErrorCopyWith<BoardError> get copyWith => _$BoardErrorCopyWithImpl<BoardError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BoardState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $BoardErrorCopyWith<$Res> implements $BoardStateCopyWith<$Res> {
  factory $BoardErrorCopyWith(BoardError value, $Res Function(BoardError) _then) = _$BoardErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$BoardErrorCopyWithImpl<$Res>
    implements $BoardErrorCopyWith<$Res> {
  _$BoardErrorCopyWithImpl(this._self, this._then);

  final BoardError _self;
  final $Res Function(BoardError) _then;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(BoardError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
