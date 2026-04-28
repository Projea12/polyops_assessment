// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_form_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskFormEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskFormEvent()';
}


}

/// @nodoc
class $TaskFormEventCopyWith<$Res>  {
$TaskFormEventCopyWith(TaskFormEvent _, $Res Function(TaskFormEvent) __);
}


/// Adds pattern-matching-related methods to [TaskFormEvent].
extension TaskFormEventPatterns on TaskFormEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskFormSubmitted value)?  submitted,TResult Function( TaskFormPriorityChanged value)?  priorityChanged,TResult Function( TaskFormDueDateChanged value)?  dueDateChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskFormSubmitted() when submitted != null:
return submitted(_that);case TaskFormPriorityChanged() when priorityChanged != null:
return priorityChanged(_that);case TaskFormDueDateChanged() when dueDateChanged != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskFormSubmitted value)  submitted,required TResult Function( TaskFormPriorityChanged value)  priorityChanged,required TResult Function( TaskFormDueDateChanged value)  dueDateChanged,}){
final _that = this;
switch (_that) {
case TaskFormSubmitted():
return submitted(_that);case TaskFormPriorityChanged():
return priorityChanged(_that);case TaskFormDueDateChanged():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskFormSubmitted value)?  submitted,TResult? Function( TaskFormPriorityChanged value)?  priorityChanged,TResult? Function( TaskFormDueDateChanged value)?  dueDateChanged,}){
final _that = this;
switch (_that) {
case TaskFormSubmitted() when submitted != null:
return submitted(_that);case TaskFormPriorityChanged() when priorityChanged != null:
return priorityChanged(_that);case TaskFormDueDateChanged() when dueDateChanged != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String title,  String description,  String richDescription,  TaskPriority priority,  DateTime? dueDate)?  submitted,TResult Function( TaskPriority priority)?  priorityChanged,TResult Function( DateTime? dueDate)?  dueDateChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskFormSubmitted() when submitted != null:
return submitted(_that.title,_that.description,_that.richDescription,_that.priority,_that.dueDate);case TaskFormPriorityChanged() when priorityChanged != null:
return priorityChanged(_that.priority);case TaskFormDueDateChanged() when dueDateChanged != null:
return dueDateChanged(_that.dueDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String title,  String description,  String richDescription,  TaskPriority priority,  DateTime? dueDate)  submitted,required TResult Function( TaskPriority priority)  priorityChanged,required TResult Function( DateTime? dueDate)  dueDateChanged,}) {final _that = this;
switch (_that) {
case TaskFormSubmitted():
return submitted(_that.title,_that.description,_that.richDescription,_that.priority,_that.dueDate);case TaskFormPriorityChanged():
return priorityChanged(_that.priority);case TaskFormDueDateChanged():
return dueDateChanged(_that.dueDate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String title,  String description,  String richDescription,  TaskPriority priority,  DateTime? dueDate)?  submitted,TResult? Function( TaskPriority priority)?  priorityChanged,TResult? Function( DateTime? dueDate)?  dueDateChanged,}) {final _that = this;
switch (_that) {
case TaskFormSubmitted() when submitted != null:
return submitted(_that.title,_that.description,_that.richDescription,_that.priority,_that.dueDate);case TaskFormPriorityChanged() when priorityChanged != null:
return priorityChanged(_that.priority);case TaskFormDueDateChanged() when dueDateChanged != null:
return dueDateChanged(_that.dueDate);case _:
  return null;

}
}

}

/// @nodoc


class TaskFormSubmitted implements TaskFormEvent {
  const TaskFormSubmitted({required this.title, required this.description, required this.richDescription, required this.priority, this.dueDate});
  

 final  String title;
 final  String description;
 final  String richDescription;
 final  TaskPriority priority;
 final  DateTime? dueDate;

/// Create a copy of TaskFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFormSubmittedCopyWith<TaskFormSubmitted> get copyWith => _$TaskFormSubmittedCopyWithImpl<TaskFormSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormSubmitted&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.richDescription, richDescription) || other.richDescription == richDescription)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,richDescription,priority,dueDate);

@override
String toString() {
  return 'TaskFormEvent.submitted(title: $title, description: $description, richDescription: $richDescription, priority: $priority, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class $TaskFormSubmittedCopyWith<$Res> implements $TaskFormEventCopyWith<$Res> {
  factory $TaskFormSubmittedCopyWith(TaskFormSubmitted value, $Res Function(TaskFormSubmitted) _then) = _$TaskFormSubmittedCopyWithImpl;
@useResult
$Res call({
 String title, String description, String richDescription, TaskPriority priority, DateTime? dueDate
});




}
/// @nodoc
class _$TaskFormSubmittedCopyWithImpl<$Res>
    implements $TaskFormSubmittedCopyWith<$Res> {
  _$TaskFormSubmittedCopyWithImpl(this._self, this._then);

  final TaskFormSubmitted _self;
  final $Res Function(TaskFormSubmitted) _then;

/// Create a copy of TaskFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? richDescription = null,Object? priority = null,Object? dueDate = freezed,}) {
  return _then(TaskFormSubmitted(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,richDescription: null == richDescription ? _self.richDescription : richDescription // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc


class TaskFormPriorityChanged implements TaskFormEvent {
  const TaskFormPriorityChanged(this.priority);
  

 final  TaskPriority priority;

/// Create a copy of TaskFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFormPriorityChangedCopyWith<TaskFormPriorityChanged> get copyWith => _$TaskFormPriorityChangedCopyWithImpl<TaskFormPriorityChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormPriorityChanged&&(identical(other.priority, priority) || other.priority == priority));
}


@override
int get hashCode => Object.hash(runtimeType,priority);

@override
String toString() {
  return 'TaskFormEvent.priorityChanged(priority: $priority)';
}


}

/// @nodoc
abstract mixin class $TaskFormPriorityChangedCopyWith<$Res> implements $TaskFormEventCopyWith<$Res> {
  factory $TaskFormPriorityChangedCopyWith(TaskFormPriorityChanged value, $Res Function(TaskFormPriorityChanged) _then) = _$TaskFormPriorityChangedCopyWithImpl;
@useResult
$Res call({
 TaskPriority priority
});




}
/// @nodoc
class _$TaskFormPriorityChangedCopyWithImpl<$Res>
    implements $TaskFormPriorityChangedCopyWith<$Res> {
  _$TaskFormPriorityChangedCopyWithImpl(this._self, this._then);

  final TaskFormPriorityChanged _self;
  final $Res Function(TaskFormPriorityChanged) _then;

/// Create a copy of TaskFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? priority = null,}) {
  return _then(TaskFormPriorityChanged(
null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,
  ));
}


}

/// @nodoc


class TaskFormDueDateChanged implements TaskFormEvent {
  const TaskFormDueDateChanged(this.dueDate);
  

 final  DateTime? dueDate;

/// Create a copy of TaskFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFormDueDateChangedCopyWith<TaskFormDueDateChanged> get copyWith => _$TaskFormDueDateChangedCopyWithImpl<TaskFormDueDateChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormDueDateChanged&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}


@override
int get hashCode => Object.hash(runtimeType,dueDate);

@override
String toString() {
  return 'TaskFormEvent.dueDateChanged(dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class $TaskFormDueDateChangedCopyWith<$Res> implements $TaskFormEventCopyWith<$Res> {
  factory $TaskFormDueDateChangedCopyWith(TaskFormDueDateChanged value, $Res Function(TaskFormDueDateChanged) _then) = _$TaskFormDueDateChangedCopyWithImpl;
@useResult
$Res call({
 DateTime? dueDate
});




}
/// @nodoc
class _$TaskFormDueDateChangedCopyWithImpl<$Res>
    implements $TaskFormDueDateChangedCopyWith<$Res> {
  _$TaskFormDueDateChangedCopyWithImpl(this._self, this._then);

  final TaskFormDueDateChanged _self;
  final $Res Function(TaskFormDueDateChanged) _then;

/// Create a copy of TaskFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? dueDate = freezed,}) {
  return _then(TaskFormDueDateChanged(
freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
