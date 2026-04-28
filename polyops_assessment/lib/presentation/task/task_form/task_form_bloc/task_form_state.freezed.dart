// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskFormState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskFormState()';
}


}

/// @nodoc
class $TaskFormStateCopyWith<$Res>  {
$TaskFormStateCopyWith(TaskFormState _, $Res Function(TaskFormState) __);
}


/// Adds pattern-matching-related methods to [TaskFormState].
extension TaskFormStatePatterns on TaskFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskFormIdle value)?  idle,TResult Function( TaskFormSubmitting value)?  submitting,TResult Function( TaskFormSuccess value)?  success,TResult Function( TaskFormFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskFormIdle() when idle != null:
return idle(_that);case TaskFormSubmitting() when submitting != null:
return submitting(_that);case TaskFormSuccess() when success != null:
return success(_that);case TaskFormFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskFormIdle value)  idle,required TResult Function( TaskFormSubmitting value)  submitting,required TResult Function( TaskFormSuccess value)  success,required TResult Function( TaskFormFailure value)  failure,}){
final _that = this;
switch (_that) {
case TaskFormIdle():
return idle(_that);case TaskFormSubmitting():
return submitting(_that);case TaskFormSuccess():
return success(_that);case TaskFormFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskFormIdle value)?  idle,TResult? Function( TaskFormSubmitting value)?  submitting,TResult? Function( TaskFormSuccess value)?  success,TResult? Function( TaskFormFailure value)?  failure,}){
final _that = this;
switch (_that) {
case TaskFormIdle() when idle != null:
return idle(_that);case TaskFormSubmitting() when submitting != null:
return submitting(_that);case TaskFormSuccess() when success != null:
return success(_that);case TaskFormFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function()?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskFormIdle() when idle != null:
return idle();case TaskFormSubmitting() when submitting != null:
return submitting();case TaskFormSuccess() when success != null:
return success();case TaskFormFailure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function()  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case TaskFormIdle():
return idle();case TaskFormSubmitting():
return submitting();case TaskFormSuccess():
return success();case TaskFormFailure():
return failure(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function()?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case TaskFormIdle() when idle != null:
return idle();case TaskFormSubmitting() when submitting != null:
return submitting();case TaskFormSuccess() when success != null:
return success();case TaskFormFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TaskFormIdle implements TaskFormState {
  const TaskFormIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskFormState.idle()';
}


}




/// @nodoc


class TaskFormSubmitting implements TaskFormState {
  const TaskFormSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskFormState.submitting()';
}


}




/// @nodoc


class TaskFormSuccess implements TaskFormState {
  const TaskFormSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskFormState.success()';
}


}




/// @nodoc


class TaskFormFailure implements TaskFormState {
  const TaskFormFailure(this.message);
  

 final  String message;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFormFailureCopyWith<TaskFormFailure> get copyWith => _$TaskFormFailureCopyWithImpl<TaskFormFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TaskFormState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $TaskFormFailureCopyWith<$Res> implements $TaskFormStateCopyWith<$Res> {
  factory $TaskFormFailureCopyWith(TaskFormFailure value, $Res Function(TaskFormFailure) _then) = _$TaskFormFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TaskFormFailureCopyWithImpl<$Res>
    implements $TaskFormFailureCopyWith<$Res> {
  _$TaskFormFailureCopyWithImpl(this._self, this._then);

  final TaskFormFailure _self;
  final $Res Function(TaskFormFailure) _then;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TaskFormFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
