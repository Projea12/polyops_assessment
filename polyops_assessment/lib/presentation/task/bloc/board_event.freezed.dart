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
@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadBoard value)?  loadBoard,TResult Function( MoveTask value)?  moveTask,TResult Function( DragStarted value)?  dragStarted,TResult Function( DragEnded value)?  dragEnded,TResult Function( HoverColumn value)?  hoverColumn,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadBoard() when loadBoard != null:
return loadBoard(_that);case MoveTask() when moveTask != null:
return moveTask(_that);case DragStarted() when dragStarted != null:
return dragStarted(_that);case DragEnded() when dragEnded != null:
return dragEnded(_that);case HoverColumn() when hoverColumn != null:
return hoverColumn(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadBoard value)  loadBoard,required TResult Function( MoveTask value)  moveTask,required TResult Function( DragStarted value)  dragStarted,required TResult Function( DragEnded value)  dragEnded,required TResult Function( HoverColumn value)  hoverColumn,}){
final _that = this;
switch (_that) {
case LoadBoard():
return loadBoard(_that);case MoveTask():
return moveTask(_that);case DragStarted():
return dragStarted(_that);case DragEnded():
return dragEnded(_that);case HoverColumn():
return hoverColumn(_that);}
}
/// A variant of `map` that fallback to returning `null`.
@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadBoard value)?  loadBoard,TResult? Function( MoveTask value)?  moveTask,TResult? Function( DragStarted value)?  dragStarted,TResult? Function( DragEnded value)?  dragEnded,TResult? Function( HoverColumn value)?  hoverColumn,}){
final _that = this;
switch (_that) {
case LoadBoard() when loadBoard != null:
return loadBoard(_that);case MoveTask() when moveTask != null:
return moveTask(_that);case DragStarted() when dragStarted != null:
return dragStarted(_that);case DragEnded() when dragEnded != null:
return dragEnded(_that);case HoverColumn() when hoverColumn != null:
return hoverColumn(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadBoard,TResult Function( String taskId,  TaskStatus from,  TaskStatus to,  int newPosition)?  moveTask,TResult Function( String taskId)?  dragStarted,TResult Function()?  dragEnded,TResult Function( TaskStatus? status)?  hoverColumn,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadBoard() when loadBoard != null:
return loadBoard();case MoveTask() when moveTask != null:
return moveTask(_that.taskId,_that.from,_that.to,_that.newPosition);case DragStarted() when dragStarted != null:
return dragStarted(_that.taskId);case DragEnded() when dragEnded != null:
return dragEnded();case HoverColumn() when hoverColumn != null:
return hoverColumn(_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadBoard,required TResult Function( String taskId,  TaskStatus from,  TaskStatus to,  int newPosition)  moveTask,required TResult Function( String taskId)  dragStarted,required TResult Function()  dragEnded,required TResult Function( TaskStatus? status)  hoverColumn,}) {final _that = this;
switch (_that) {
case LoadBoard():
return loadBoard();case MoveTask():
return moveTask(_that.taskId,_that.from,_that.to,_that.newPosition);case DragStarted():
return dragStarted(_that.taskId);case DragEnded():
return dragEnded();case HoverColumn():
return hoverColumn(_that.status);}
}
/// A variant of `when` that fallback to returning `null`
@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadBoard,TResult? Function( String taskId,  TaskStatus from,  TaskStatus to,  int newPosition)?  moveTask,TResult? Function( String taskId)?  dragStarted,TResult? Function()?  dragEnded,TResult? Function( TaskStatus? status)?  hoverColumn,}) {final _that = this;
switch (_that) {
case LoadBoard() when loadBoard != null:
return loadBoard();case MoveTask() when moveTask != null:
return moveTask(_that.taskId,_that.from,_that.to,_that.newPosition);case DragStarted() when dragStarted != null:
return dragStarted(_that.taskId);case DragEnded() when dragEnded != null:
return dragEnded();case HoverColumn() when hoverColumn != null:
return hoverColumn(_that.status);case _:
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

/// @nodoc


class DragStarted implements BoardEvent {
  const DragStarted({required this.taskId});


 final  String taskId;

/// Create a copy of BoardEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DragStartedCopyWith<DragStarted> get copyWith => _$DragStartedCopyWithImpl<DragStarted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DragStarted&&(identical(other.taskId, taskId) || other.taskId == taskId));
}


@override
int get hashCode => Object.hash(runtimeType,taskId);

@override
String toString() {
  return 'BoardEvent.dragStarted(taskId: $taskId)';
}


}

/// @nodoc
abstract mixin class $DragStartedCopyWith<$Res> implements $BoardEventCopyWith<$Res> {
  factory $DragStartedCopyWith(DragStarted value, $Res Function(DragStarted) _then) = _$DragStartedCopyWithImpl;
@useResult
$Res call({
 String taskId
});




}
/// @nodoc
class _$DragStartedCopyWithImpl<$Res>
    implements $DragStartedCopyWith<$Res> {
  _$DragStartedCopyWithImpl(this._self, this._then);

  final DragStarted _self;
  final $Res Function(DragStarted) _then;

/// Create a copy of BoardEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? taskId = null,}) {
  return _then(DragStarted(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DragEnded implements BoardEvent {
  const DragEnded();





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DragEnded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BoardEvent.dragEnded()';
}


}




/// @nodoc


class HoverColumn implements BoardEvent {
  const HoverColumn({this.status});


 final  TaskStatus? status;

/// Create a copy of BoardEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoverColumnCopyWith<HoverColumn> get copyWith => _$HoverColumnCopyWithImpl<HoverColumn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HoverColumn&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'BoardEvent.hoverColumn(status: $status)';
}


}

/// @nodoc
abstract mixin class $HoverColumnCopyWith<$Res> implements $BoardEventCopyWith<$Res> {
  factory $HoverColumnCopyWith(HoverColumn value, $Res Function(HoverColumn) _then) = _$HoverColumnCopyWithImpl;
@useResult
$Res call({
 TaskStatus? status
});




}
/// @nodoc
class _$HoverColumnCopyWithImpl<$Res>
    implements $HoverColumnCopyWith<$Res> {
  _$HoverColumnCopyWithImpl(this._self, this._then);

  final HoverColumn _self;
  final $Res Function(HoverColumn) _then;

/// Create a copy of BoardEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? status = freezed,}) {
  return _then(HoverColumn(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus?,
  ));
}


}

// dart format on
