// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_detail_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskDetailEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailEvent()';
}


}

/// @nodoc
class $TaskDetailEventCopyWith<$Res>  {
$TaskDetailEventCopyWith(TaskDetailEvent _, $Res Function(TaskDetailEvent) __);
}


/// Adds pattern-matching-related methods to [TaskDetailEvent].
extension TaskDetailEventPatterns on TaskDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskDetailSubscribed value)?  subscribed,TResult Function( TaskDetailSaveRequested value)?  saveRequested,TResult Function( TaskDetailDeleteRequested value)?  deleteRequested,TResult Function( TaskDetailCommentSubmitted value)?  commentSubmitted,TResult Function( TaskDetailEditEntered value)?  editEntered,TResult Function( TaskDetailEditCancelled value)?  editCancelled,TResult Function( TaskDetailStatusChanged value)?  statusChanged,TResult Function( TaskDetailPriorityChanged value)?  priorityChanged,TResult Function( TaskDetailDueDateChanged value)?  dueDateChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskDetailSubscribed() when subscribed != null:
return subscribed(_that);case TaskDetailSaveRequested() when saveRequested != null:
return saveRequested(_that);case TaskDetailDeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case TaskDetailCommentSubmitted() when commentSubmitted != null:
return commentSubmitted(_that);case TaskDetailEditEntered() when editEntered != null:
return editEntered(_that);case TaskDetailEditCancelled() when editCancelled != null:
return editCancelled(_that);case TaskDetailStatusChanged() when statusChanged != null:
return statusChanged(_that);case TaskDetailPriorityChanged() when priorityChanged != null:
return priorityChanged(_that);case TaskDetailDueDateChanged() when dueDateChanged != null:
return dueDateChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskDetailSubscribed value)  subscribed,required TResult Function( TaskDetailSaveRequested value)  saveRequested,required TResult Function( TaskDetailDeleteRequested value)  deleteRequested,required TResult Function( TaskDetailCommentSubmitted value)  commentSubmitted,required TResult Function( TaskDetailEditEntered value)  editEntered,required TResult Function( TaskDetailEditCancelled value)  editCancelled,required TResult Function( TaskDetailStatusChanged value)  statusChanged,required TResult Function( TaskDetailPriorityChanged value)  priorityChanged,required TResult Function( TaskDetailDueDateChanged value)  dueDateChanged,}){
final _that = this;
switch (_that) {
case TaskDetailSubscribed():
return subscribed(_that);case TaskDetailSaveRequested():
return saveRequested(_that);case TaskDetailDeleteRequested():
return deleteRequested(_that);case TaskDetailCommentSubmitted():
return commentSubmitted(_that);case TaskDetailEditEntered():
return editEntered(_that);case TaskDetailEditCancelled():
return editCancelled(_that);case TaskDetailStatusChanged():
return statusChanged(_that);case TaskDetailPriorityChanged():
return priorityChanged(_that);case TaskDetailDueDateChanged():
return dueDateChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskDetailSubscribed value)?  subscribed,TResult? Function( TaskDetailSaveRequested value)?  saveRequested,TResult? Function( TaskDetailDeleteRequested value)?  deleteRequested,TResult? Function( TaskDetailCommentSubmitted value)?  commentSubmitted,TResult? Function( TaskDetailEditEntered value)?  editEntered,TResult? Function( TaskDetailEditCancelled value)?  editCancelled,TResult? Function( TaskDetailStatusChanged value)?  statusChanged,TResult? Function( TaskDetailPriorityChanged value)?  priorityChanged,TResult? Function( TaskDetailDueDateChanged value)?  dueDateChanged,}){
final _that = this;
switch (_that) {
case TaskDetailSubscribed() when subscribed != null:
return subscribed(_that);case TaskDetailSaveRequested() when saveRequested != null:
return saveRequested(_that);case TaskDetailDeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case TaskDetailCommentSubmitted() when commentSubmitted != null:
return commentSubmitted(_that);case TaskDetailEditEntered() when editEntered != null:
return editEntered(_that);case TaskDetailEditCancelled() when editCancelled != null:
return editCancelled(_that);case TaskDetailStatusChanged() when statusChanged != null:
return statusChanged(_that);case TaskDetailPriorityChanged() when priorityChanged != null:
return priorityChanged(_that);case TaskDetailDueDateChanged() when dueDateChanged != null:
return dueDateChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String taskId)?  subscribed,TResult Function( Task task)?  saveRequested,TResult Function( String taskId)?  deleteRequested,TResult Function( String taskId,  String content)?  commentSubmitted,TResult Function()?  editEntered,TResult Function()?  editCancelled,TResult Function( TaskStatus status)?  statusChanged,TResult Function( TaskPriority priority)?  priorityChanged,TResult Function( DateTime? date)?  dueDateChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskDetailSubscribed() when subscribed != null:
return subscribed(_that.taskId);case TaskDetailSaveRequested() when saveRequested != null:
return saveRequested(_that.task);case TaskDetailDeleteRequested() when deleteRequested != null:
return deleteRequested(_that.taskId);case TaskDetailCommentSubmitted() when commentSubmitted != null:
return commentSubmitted(_that.taskId,_that.content);case TaskDetailEditEntered() when editEntered != null:
return editEntered();case TaskDetailEditCancelled() when editCancelled != null:
return editCancelled();case TaskDetailStatusChanged() when statusChanged != null:
return statusChanged(_that.status);case TaskDetailPriorityChanged() when priorityChanged != null:
return priorityChanged(_that.priority);case TaskDetailDueDateChanged() when dueDateChanged != null:
return dueDateChanged(_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String taskId)  subscribed,required TResult Function( Task task)  saveRequested,required TResult Function( String taskId)  deleteRequested,required TResult Function( String taskId,  String content)  commentSubmitted,required TResult Function()  editEntered,required TResult Function()  editCancelled,required TResult Function( TaskStatus status)  statusChanged,required TResult Function( TaskPriority priority)  priorityChanged,required TResult Function( DateTime? date)  dueDateChanged,}) {final _that = this;
switch (_that) {
case TaskDetailSubscribed():
return subscribed(_that.taskId);case TaskDetailSaveRequested():
return saveRequested(_that.task);case TaskDetailDeleteRequested():
return deleteRequested(_that.taskId);case TaskDetailCommentSubmitted():
return commentSubmitted(_that.taskId,_that.content);case TaskDetailEditEntered():
return editEntered();case TaskDetailEditCancelled():
return editCancelled();case TaskDetailStatusChanged():
return statusChanged(_that.status);case TaskDetailPriorityChanged():
return priorityChanged(_that.priority);case TaskDetailDueDateChanged():
return dueDateChanged(_that.date);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String taskId)?  subscribed,TResult? Function( Task task)?  saveRequested,TResult? Function( String taskId)?  deleteRequested,TResult? Function( String taskId,  String content)?  commentSubmitted,TResult? Function()?  editEntered,TResult? Function()?  editCancelled,TResult? Function( TaskStatus status)?  statusChanged,TResult? Function( TaskPriority priority)?  priorityChanged,TResult? Function( DateTime? date)?  dueDateChanged,}) {final _that = this;
switch (_that) {
case TaskDetailSubscribed() when subscribed != null:
return subscribed(_that.taskId);case TaskDetailSaveRequested() when saveRequested != null:
return saveRequested(_that.task);case TaskDetailDeleteRequested() when deleteRequested != null:
return deleteRequested(_that.taskId);case TaskDetailCommentSubmitted() when commentSubmitted != null:
return commentSubmitted(_that.taskId,_that.content);case TaskDetailEditEntered() when editEntered != null:
return editEntered();case TaskDetailEditCancelled() when editCancelled != null:
return editCancelled();case TaskDetailStatusChanged() when statusChanged != null:
return statusChanged(_that.status);case TaskDetailPriorityChanged() when priorityChanged != null:
return priorityChanged(_that.priority);case TaskDetailDueDateChanged() when dueDateChanged != null:
return dueDateChanged(_that.date);case _:
  return null;

}
}

}

/// @nodoc


class TaskDetailSubscribed implements TaskDetailEvent {
  const TaskDetailSubscribed(this.taskId);
  

 final  String taskId;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailSubscribedCopyWith<TaskDetailSubscribed> get copyWith => _$TaskDetailSubscribedCopyWithImpl<TaskDetailSubscribed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailSubscribed&&(identical(other.taskId, taskId) || other.taskId == taskId));
}


@override
int get hashCode => Object.hash(runtimeType,taskId);

@override
String toString() {
  return 'TaskDetailEvent.subscribed(taskId: $taskId)';
}


}

/// @nodoc
abstract mixin class $TaskDetailSubscribedCopyWith<$Res> implements $TaskDetailEventCopyWith<$Res> {
  factory $TaskDetailSubscribedCopyWith(TaskDetailSubscribed value, $Res Function(TaskDetailSubscribed) _then) = _$TaskDetailSubscribedCopyWithImpl;
@useResult
$Res call({
 String taskId
});




}
/// @nodoc
class _$TaskDetailSubscribedCopyWithImpl<$Res>
    implements $TaskDetailSubscribedCopyWith<$Res> {
  _$TaskDetailSubscribedCopyWithImpl(this._self, this._then);

  final TaskDetailSubscribed _self;
  final $Res Function(TaskDetailSubscribed) _then;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? taskId = null,}) {
  return _then(TaskDetailSubscribed(
null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TaskDetailSaveRequested implements TaskDetailEvent {
  const TaskDetailSaveRequested(this.task);
  

 final  Task task;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailSaveRequestedCopyWith<TaskDetailSaveRequested> get copyWith => _$TaskDetailSaveRequestedCopyWithImpl<TaskDetailSaveRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailSaveRequested&&(identical(other.task, task) || other.task == task));
}


@override
int get hashCode => Object.hash(runtimeType,task);

@override
String toString() {
  return 'TaskDetailEvent.saveRequested(task: $task)';
}


}

/// @nodoc
abstract mixin class $TaskDetailSaveRequestedCopyWith<$Res> implements $TaskDetailEventCopyWith<$Res> {
  factory $TaskDetailSaveRequestedCopyWith(TaskDetailSaveRequested value, $Res Function(TaskDetailSaveRequested) _then) = _$TaskDetailSaveRequestedCopyWithImpl;
@useResult
$Res call({
 Task task
});




}
/// @nodoc
class _$TaskDetailSaveRequestedCopyWithImpl<$Res>
    implements $TaskDetailSaveRequestedCopyWith<$Res> {
  _$TaskDetailSaveRequestedCopyWithImpl(this._self, this._then);

  final TaskDetailSaveRequested _self;
  final $Res Function(TaskDetailSaveRequested) _then;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? task = null,}) {
  return _then(TaskDetailSaveRequested(
null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as Task,
  ));
}


}

/// @nodoc


class TaskDetailDeleteRequested implements TaskDetailEvent {
  const TaskDetailDeleteRequested(this.taskId);
  

 final  String taskId;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailDeleteRequestedCopyWith<TaskDetailDeleteRequested> get copyWith => _$TaskDetailDeleteRequestedCopyWithImpl<TaskDetailDeleteRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailDeleteRequested&&(identical(other.taskId, taskId) || other.taskId == taskId));
}


@override
int get hashCode => Object.hash(runtimeType,taskId);

@override
String toString() {
  return 'TaskDetailEvent.deleteRequested(taskId: $taskId)';
}


}

/// @nodoc
abstract mixin class $TaskDetailDeleteRequestedCopyWith<$Res> implements $TaskDetailEventCopyWith<$Res> {
  factory $TaskDetailDeleteRequestedCopyWith(TaskDetailDeleteRequested value, $Res Function(TaskDetailDeleteRequested) _then) = _$TaskDetailDeleteRequestedCopyWithImpl;
@useResult
$Res call({
 String taskId
});




}
/// @nodoc
class _$TaskDetailDeleteRequestedCopyWithImpl<$Res>
    implements $TaskDetailDeleteRequestedCopyWith<$Res> {
  _$TaskDetailDeleteRequestedCopyWithImpl(this._self, this._then);

  final TaskDetailDeleteRequested _self;
  final $Res Function(TaskDetailDeleteRequested) _then;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? taskId = null,}) {
  return _then(TaskDetailDeleteRequested(
null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TaskDetailCommentSubmitted implements TaskDetailEvent {
  const TaskDetailCommentSubmitted({required this.taskId, required this.content});
  

 final  String taskId;
 final  String content;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailCommentSubmittedCopyWith<TaskDetailCommentSubmitted> get copyWith => _$TaskDetailCommentSubmittedCopyWithImpl<TaskDetailCommentSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailCommentSubmitted&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,taskId,content);

@override
String toString() {
  return 'TaskDetailEvent.commentSubmitted(taskId: $taskId, content: $content)';
}


}

/// @nodoc
abstract mixin class $TaskDetailCommentSubmittedCopyWith<$Res> implements $TaskDetailEventCopyWith<$Res> {
  factory $TaskDetailCommentSubmittedCopyWith(TaskDetailCommentSubmitted value, $Res Function(TaskDetailCommentSubmitted) _then) = _$TaskDetailCommentSubmittedCopyWithImpl;
@useResult
$Res call({
 String taskId, String content
});




}
/// @nodoc
class _$TaskDetailCommentSubmittedCopyWithImpl<$Res>
    implements $TaskDetailCommentSubmittedCopyWith<$Res> {
  _$TaskDetailCommentSubmittedCopyWithImpl(this._self, this._then);

  final TaskDetailCommentSubmitted _self;
  final $Res Function(TaskDetailCommentSubmitted) _then;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? content = null,}) {
  return _then(TaskDetailCommentSubmitted(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TaskDetailEditEntered implements TaskDetailEvent {
  const TaskDetailEditEntered();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailEditEntered);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailEvent.editEntered()';
}


}




/// @nodoc


class TaskDetailEditCancelled implements TaskDetailEvent {
  const TaskDetailEditCancelled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailEditCancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailEvent.editCancelled()';
}


}




/// @nodoc


class TaskDetailStatusChanged implements TaskDetailEvent {
  const TaskDetailStatusChanged(this.status);
  

 final  TaskStatus status;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailStatusChangedCopyWith<TaskDetailStatusChanged> get copyWith => _$TaskDetailStatusChangedCopyWithImpl<TaskDetailStatusChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailStatusChanged&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'TaskDetailEvent.statusChanged(status: $status)';
}


}

/// @nodoc
abstract mixin class $TaskDetailStatusChangedCopyWith<$Res> implements $TaskDetailEventCopyWith<$Res> {
  factory $TaskDetailStatusChangedCopyWith(TaskDetailStatusChanged value, $Res Function(TaskDetailStatusChanged) _then) = _$TaskDetailStatusChangedCopyWithImpl;
@useResult
$Res call({
 TaskStatus status
});




}
/// @nodoc
class _$TaskDetailStatusChangedCopyWithImpl<$Res>
    implements $TaskDetailStatusChangedCopyWith<$Res> {
  _$TaskDetailStatusChangedCopyWithImpl(this._self, this._then);

  final TaskDetailStatusChanged _self;
  final $Res Function(TaskDetailStatusChanged) _then;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(TaskDetailStatusChanged(
null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,
  ));
}


}

/// @nodoc


class TaskDetailPriorityChanged implements TaskDetailEvent {
  const TaskDetailPriorityChanged(this.priority);
  

 final  TaskPriority priority;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailPriorityChangedCopyWith<TaskDetailPriorityChanged> get copyWith => _$TaskDetailPriorityChangedCopyWithImpl<TaskDetailPriorityChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailPriorityChanged&&(identical(other.priority, priority) || other.priority == priority));
}


@override
int get hashCode => Object.hash(runtimeType,priority);

@override
String toString() {
  return 'TaskDetailEvent.priorityChanged(priority: $priority)';
}


}

/// @nodoc
abstract mixin class $TaskDetailPriorityChangedCopyWith<$Res> implements $TaskDetailEventCopyWith<$Res> {
  factory $TaskDetailPriorityChangedCopyWith(TaskDetailPriorityChanged value, $Res Function(TaskDetailPriorityChanged) _then) = _$TaskDetailPriorityChangedCopyWithImpl;
@useResult
$Res call({
 TaskPriority priority
});




}
/// @nodoc
class _$TaskDetailPriorityChangedCopyWithImpl<$Res>
    implements $TaskDetailPriorityChangedCopyWith<$Res> {
  _$TaskDetailPriorityChangedCopyWithImpl(this._self, this._then);

  final TaskDetailPriorityChanged _self;
  final $Res Function(TaskDetailPriorityChanged) _then;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? priority = null,}) {
  return _then(TaskDetailPriorityChanged(
null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,
  ));
}


}

/// @nodoc


class TaskDetailDueDateChanged implements TaskDetailEvent {
  const TaskDetailDueDateChanged(this.date);
  

 final  DateTime? date;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailDueDateChangedCopyWith<TaskDetailDueDateChanged> get copyWith => _$TaskDetailDueDateChangedCopyWithImpl<TaskDetailDueDateChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailDueDateChanged&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,date);

@override
String toString() {
  return 'TaskDetailEvent.dueDateChanged(date: $date)';
}


}

/// @nodoc
abstract mixin class $TaskDetailDueDateChangedCopyWith<$Res> implements $TaskDetailEventCopyWith<$Res> {
  factory $TaskDetailDueDateChangedCopyWith(TaskDetailDueDateChanged value, $Res Function(TaskDetailDueDateChanged) _then) = _$TaskDetailDueDateChangedCopyWithImpl;
@useResult
$Res call({
 DateTime? date
});




}
/// @nodoc
class _$TaskDetailDueDateChangedCopyWithImpl<$Res>
    implements $TaskDetailDueDateChangedCopyWith<$Res> {
  _$TaskDetailDueDateChangedCopyWithImpl(this._self, this._then);

  final TaskDetailDueDateChanged _self;
  final $Res Function(TaskDetailDueDateChanged) _then;

/// Create a copy of TaskDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? date = freezed,}) {
  return _then(TaskDetailDueDateChanged(
freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
