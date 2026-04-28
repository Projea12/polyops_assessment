// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailState()';
}


}

/// @nodoc
class $TaskDetailStateCopyWith<$Res>  {
$TaskDetailStateCopyWith(TaskDetailState _, $Res Function(TaskDetailState) __);
}


/// Adds pattern-matching-related methods to [TaskDetailState].
extension TaskDetailStatePatterns on TaskDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskDetailInitial value)?  initial,TResult Function( TaskDetailLoading value)?  loading,TResult Function( TaskDetailLoaded value)?  loaded,TResult Function( TaskDetailSaveSuccess value)?  saveSuccess,TResult Function( TaskDetailDeleteSuccess value)?  deleteSuccess,TResult Function( TaskDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskDetailInitial() when initial != null:
return initial(_that);case TaskDetailLoading() when loading != null:
return loading(_that);case TaskDetailLoaded() when loaded != null:
return loaded(_that);case TaskDetailSaveSuccess() when saveSuccess != null:
return saveSuccess(_that);case TaskDetailDeleteSuccess() when deleteSuccess != null:
return deleteSuccess(_that);case TaskDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskDetailInitial value)  initial,required TResult Function( TaskDetailLoading value)  loading,required TResult Function( TaskDetailLoaded value)  loaded,required TResult Function( TaskDetailSaveSuccess value)  saveSuccess,required TResult Function( TaskDetailDeleteSuccess value)  deleteSuccess,required TResult Function( TaskDetailError value)  error,}){
final _that = this;
switch (_that) {
case TaskDetailInitial():
return initial(_that);case TaskDetailLoading():
return loading(_that);case TaskDetailLoaded():
return loaded(_that);case TaskDetailSaveSuccess():
return saveSuccess(_that);case TaskDetailDeleteSuccess():
return deleteSuccess(_that);case TaskDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskDetailInitial value)?  initial,TResult? Function( TaskDetailLoading value)?  loading,TResult? Function( TaskDetailLoaded value)?  loaded,TResult? Function( TaskDetailSaveSuccess value)?  saveSuccess,TResult? Function( TaskDetailDeleteSuccess value)?  deleteSuccess,TResult? Function( TaskDetailError value)?  error,}){
final _that = this;
switch (_that) {
case TaskDetailInitial() when initial != null:
return initial(_that);case TaskDetailLoading() when loading != null:
return loading(_that);case TaskDetailLoaded() when loaded != null:
return loaded(_that);case TaskDetailSaveSuccess() when saveSuccess != null:
return saveSuccess(_that);case TaskDetailDeleteSuccess() when deleteSuccess != null:
return deleteSuccess(_that);case TaskDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Task task,  bool isSaving,  bool isSubmittingComment,  bool isEditing,  TaskPriority? draftPriority,  TaskStatus? draftStatus,  DateTime? draftDueDate,  String? operationError)?  loaded,TResult Function()?  saveSuccess,TResult Function()?  deleteSuccess,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskDetailInitial() when initial != null:
return initial();case TaskDetailLoading() when loading != null:
return loading();case TaskDetailLoaded() when loaded != null:
return loaded(_that.task,_that.isSaving,_that.isSubmittingComment,_that.isEditing,_that.draftPriority,_that.draftStatus,_that.draftDueDate,_that.operationError);case TaskDetailSaveSuccess() when saveSuccess != null:
return saveSuccess();case TaskDetailDeleteSuccess() when deleteSuccess != null:
return deleteSuccess();case TaskDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Task task,  bool isSaving,  bool isSubmittingComment,  bool isEditing,  TaskPriority? draftPriority,  TaskStatus? draftStatus,  DateTime? draftDueDate,  String? operationError)  loaded,required TResult Function()  saveSuccess,required TResult Function()  deleteSuccess,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case TaskDetailInitial():
return initial();case TaskDetailLoading():
return loading();case TaskDetailLoaded():
return loaded(_that.task,_that.isSaving,_that.isSubmittingComment,_that.isEditing,_that.draftPriority,_that.draftStatus,_that.draftDueDate,_that.operationError);case TaskDetailSaveSuccess():
return saveSuccess();case TaskDetailDeleteSuccess():
return deleteSuccess();case TaskDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Task task,  bool isSaving,  bool isSubmittingComment,  bool isEditing,  TaskPriority? draftPriority,  TaskStatus? draftStatus,  DateTime? draftDueDate,  String? operationError)?  loaded,TResult? Function()?  saveSuccess,TResult? Function()?  deleteSuccess,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case TaskDetailInitial() when initial != null:
return initial();case TaskDetailLoading() when loading != null:
return loading();case TaskDetailLoaded() when loaded != null:
return loaded(_that.task,_that.isSaving,_that.isSubmittingComment,_that.isEditing,_that.draftPriority,_that.draftStatus,_that.draftDueDate,_that.operationError);case TaskDetailSaveSuccess() when saveSuccess != null:
return saveSuccess();case TaskDetailDeleteSuccess() when deleteSuccess != null:
return deleteSuccess();case TaskDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TaskDetailInitial implements TaskDetailState {
  const TaskDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailState.initial()';
}


}




/// @nodoc


class TaskDetailLoading implements TaskDetailState {
  const TaskDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailState.loading()';
}


}




/// @nodoc


class TaskDetailLoaded implements TaskDetailState {
  const TaskDetailLoaded({required this.task, this.isSaving = false, this.isSubmittingComment = false, this.isEditing = false, this.draftPriority, this.draftStatus, this.draftDueDate, this.operationError});
  

 final  Task task;
@JsonKey() final  bool isSaving;
@JsonKey() final  bool isSubmittingComment;
@JsonKey() final  bool isEditing;
 final  TaskPriority? draftPriority;
 final  TaskStatus? draftStatus;
 final  DateTime? draftDueDate;
 final  String? operationError;

/// Create a copy of TaskDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailLoadedCopyWith<TaskDetailLoaded> get copyWith => _$TaskDetailLoadedCopyWithImpl<TaskDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailLoaded&&(identical(other.task, task) || other.task == task)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isSubmittingComment, isSubmittingComment) || other.isSubmittingComment == isSubmittingComment)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing)&&(identical(other.draftPriority, draftPriority) || other.draftPriority == draftPriority)&&(identical(other.draftStatus, draftStatus) || other.draftStatus == draftStatus)&&(identical(other.draftDueDate, draftDueDate) || other.draftDueDate == draftDueDate)&&(identical(other.operationError, operationError) || other.operationError == operationError));
}


@override
int get hashCode => Object.hash(runtimeType,task,isSaving,isSubmittingComment,isEditing,draftPriority,draftStatus,draftDueDate,operationError);

@override
String toString() {
  return 'TaskDetailState.loaded(task: $task, isSaving: $isSaving, isSubmittingComment: $isSubmittingComment, isEditing: $isEditing, draftPriority: $draftPriority, draftStatus: $draftStatus, draftDueDate: $draftDueDate, operationError: $operationError)';
}


}

/// @nodoc
abstract mixin class $TaskDetailLoadedCopyWith<$Res> implements $TaskDetailStateCopyWith<$Res> {
  factory $TaskDetailLoadedCopyWith(TaskDetailLoaded value, $Res Function(TaskDetailLoaded) _then) = _$TaskDetailLoadedCopyWithImpl;
@useResult
$Res call({
 Task task, bool isSaving, bool isSubmittingComment, bool isEditing, TaskPriority? draftPriority, TaskStatus? draftStatus, DateTime? draftDueDate, String? operationError
});




}
/// @nodoc
class _$TaskDetailLoadedCopyWithImpl<$Res>
    implements $TaskDetailLoadedCopyWith<$Res> {
  _$TaskDetailLoadedCopyWithImpl(this._self, this._then);

  final TaskDetailLoaded _self;
  final $Res Function(TaskDetailLoaded) _then;

/// Create a copy of TaskDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? task = null,Object? isSaving = null,Object? isSubmittingComment = null,Object? isEditing = null,Object? draftPriority = freezed,Object? draftStatus = freezed,Object? draftDueDate = freezed,Object? operationError = freezed,}) {
  return _then(TaskDetailLoaded(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as Task,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isSubmittingComment: null == isSubmittingComment ? _self.isSubmittingComment : isSubmittingComment // ignore: cast_nullable_to_non_nullable
as bool,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,draftPriority: freezed == draftPriority ? _self.draftPriority : draftPriority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,draftStatus: freezed == draftStatus ? _self.draftStatus : draftStatus // ignore: cast_nullable_to_non_nullable
as TaskStatus?,draftDueDate: freezed == draftDueDate ? _self.draftDueDate : draftDueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,operationError: freezed == operationError ? _self.operationError : operationError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class TaskDetailSaveSuccess implements TaskDetailState {
  const TaskDetailSaveSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailSaveSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailState.saveSuccess()';
}


}




/// @nodoc


class TaskDetailDeleteSuccess implements TaskDetailState {
  const TaskDetailDeleteSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailDeleteSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailState.deleteSuccess()';
}


}




/// @nodoc


class TaskDetailError implements TaskDetailState {
  const TaskDetailError(this.message);
  

 final  String message;

/// Create a copy of TaskDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailErrorCopyWith<TaskDetailError> get copyWith => _$TaskDetailErrorCopyWithImpl<TaskDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TaskDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TaskDetailErrorCopyWith<$Res> implements $TaskDetailStateCopyWith<$Res> {
  factory $TaskDetailErrorCopyWith(TaskDetailError value, $Res Function(TaskDetailError) _then) = _$TaskDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TaskDetailErrorCopyWithImpl<$Res>
    implements $TaskDetailErrorCopyWith<$Res> {
  _$TaskDetailErrorCopyWithImpl(this._self, this._then);

  final TaskDetailError _self;
  final $Res Function(TaskDetailError) _then;

/// Create a copy of TaskDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TaskDetailError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
