// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoardEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BoardEvent()';
}


}

/// @nodoc
class $BoardEventCopyWith<$Res>  {
$BoardEventCopyWith(BoardEvent _, $Res Function(BoardEvent) __);
}


/// Adds pattern-matching-related methods to [BoardEvent].
extension BoardEventPatterns on BoardEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadBoard value)?  loadBoard,TResult Function( MoveTask value)?  moveTask,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadBoard() when loadBoard != null:
return loadBoard(_that);case MoveTask() when moveTask != null:
return moveTask(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadBoard value)  loadBoard,required TResult Function( MoveTask value)  moveTask,}){
final _that = this;
switch (_that) {
case LoadBoard():
return loadBoard(_that);case MoveTask():
return moveTask(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadBoard value)?  loadBoard,TResult? Function( MoveTask value)?  moveTask,}){
final _that = this;
switch (_that) {
case LoadBoard() when loadBoard != null:
return loadBoard(_that);case MoveTask() when moveTask != null:
return moveTask(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadBoard,TResult Function( String taskId,  TaskStatus from,  TaskStatus to,  int newPosition)?  moveTask,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadBoard() when loadBoard != null:
return loadBoard();case MoveTask() when moveTask != null:
return moveTask(_that.taskId,_that.from,_that.to,_that.newPosition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadBoard,required TResult Function( String taskId,  TaskStatus from,  TaskStatus to,  int newPosition)  moveTask,}) {final _that = this;
switch (_that) {
case LoadBoard():
return loadBoard();case MoveTask():
return moveTask(_that.taskId,_that.from,_that.to,_that.newPosition);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadBoard,TResult? Function( String taskId,  TaskStatus from,  TaskStatus to,  int newPosition)?  moveTask,}) {final _that = this;
switch (_that) {
case LoadBoard() when loadBoard != null:
return loadBoard();case MoveTask() when moveTask != null:
return moveTask(_that.taskId,_that.from,_that.to,_that.newPosition);case _:
  return null;

}
}

}

/// @nodoc


class LoadBoard implements BoardEvent {
  const LoadBoard();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadBoard);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BoardEvent.loadBoard()';
}


}




/// @nodoc


class MoveTask implements BoardEvent {
  const MoveTask({required this.taskId, required this.from, required this.to, required this.newPosition});
  

 final  String taskId;
 final  TaskStatus from;
 final  TaskStatus to;
 final  int newPosition;

/// Create a copy of BoardEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoveTaskCopyWith<MoveTask> get copyWith => _$MoveTaskCopyWithImpl<MoveTask>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoveTask&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.newPosition, newPosition) || other.newPosition == newPosition));
}


@override
int get hashCode => Object.hash(runtimeType,taskId,from,to,newPosition);

@override
String toString() {
  return 'BoardEvent.moveTask(taskId: $taskId, from: $from, to: $to, newPosition: $newPosition)';
}


}

/// @nodoc
abstract mixin class $MoveTaskCopyWith<$Res> implements $BoardEventCopyWith<$Res> {
  factory $MoveTaskCopyWith(MoveTask value, $Res Function(MoveTask) _then) = _$MoveTaskCopyWithImpl;
@useResult
$Res call({
 String taskId, TaskStatus from, TaskStatus to, int newPosition
});




}
/// @nodoc
class _$MoveTaskCopyWithImpl<$Res>
    implements $MoveTaskCopyWith<$Res> {
  _$MoveTaskCopyWithImpl(this._self, this._then);

  final MoveTask _self;
  final $Res Function(MoveTask) _then;

/// Create a copy of BoardEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? from = null,Object? to = null,Object? newPosition = null,}) {
  return _then(MoveTask(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as TaskStatus,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as TaskStatus,newPosition: null == newPosition ? _self.newPosition : newPosition // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
