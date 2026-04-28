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

 String get title; String get description; String get richDescription; TaskPriority get priority; DateTime? get dueDate;
/// Create a copy of TaskFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFormEventCopyWith<TaskFormEvent> get copyWith => _$TaskFormEventCopyWithImpl<TaskFormEvent>(this as TaskFormEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormEvent&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.richDescription, richDescription) || other.richDescription == richDescription)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,richDescription,priority,dueDate);

@override
String toString() {
  return 'TaskFormEvent(title: $title, description: $description, richDescription: $richDescription, priority: $priority, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class $TaskFormEventCopyWith<$Res>  {
  factory $TaskFormEventCopyWith(TaskFormEvent value, $Res Function(TaskFormEvent) _then) = _$TaskFormEventCopyWithImpl;
@useResult
$Res call({
 String title, String description, String richDescription, TaskPriority priority, DateTime? dueDate
});




}
/// @nodoc
class _$TaskFormEventCopyWithImpl<$Res>
    implements $TaskFormEventCopyWith<$Res> {
  _$TaskFormEventCopyWithImpl(this._self, this._then);

  final TaskFormEvent _self;
  final $Res Function(TaskFormEvent) _then;

/// Create a copy of TaskFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? richDescription = null,Object? priority = null,Object? dueDate = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,richDescription: null == richDescription ? _self.richDescription : richDescription // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskFormSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskFormSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskFormSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case TaskFormSubmitted():
return submitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskFormSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case TaskFormSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String title,  String description,  String richDescription,  TaskPriority priority,  DateTime? dueDate)?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskFormSubmitted() when submitted != null:
return submitted(_that.title,_that.description,_that.richDescription,_that.priority,_that.dueDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String title,  String description,  String richDescription,  TaskPriority priority,  DateTime? dueDate)  submitted,}) {final _that = this;
switch (_that) {
case TaskFormSubmitted():
return submitted(_that.title,_that.description,_that.richDescription,_that.priority,_that.dueDate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String title,  String description,  String richDescription,  TaskPriority priority,  DateTime? dueDate)?  submitted,}) {final _that = this;
switch (_that) {
case TaskFormSubmitted() when submitted != null:
return submitted(_that.title,_that.description,_that.richDescription,_that.priority,_that.dueDate);case _:
  return null;

}
}

}

/// @nodoc


class TaskFormSubmitted implements TaskFormEvent {
  const TaskFormSubmitted({required this.title, required this.description, required this.richDescription, required this.priority, this.dueDate});
  

@override final  String title;
@override final  String description;
@override final  String richDescription;
@override final  TaskPriority priority;
@override final  DateTime? dueDate;

/// Create a copy of TaskFormEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
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
@override @useResult
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
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? richDescription = null,Object? priority = null,Object? dueDate = freezed,}) {
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

// dart format on
