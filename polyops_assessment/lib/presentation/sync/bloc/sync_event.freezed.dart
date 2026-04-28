// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncEvent()';
}


}

/// @nodoc
class $SyncEventCopyWith<$Res>  {
$SyncEventCopyWith(SyncEvent _, $Res Function(SyncEvent) __);
}


/// Adds pattern-matching-related methods to [SyncEvent].
extension SyncEventPatterns on SyncEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SyncStarted value)?  started,TResult Function( SyncTriggered value)?  triggered,TResult Function( ConflictResolved value)?  conflictResolved,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SyncStarted() when started != null:
return started(_that);case SyncTriggered() when triggered != null:
return triggered(_that);case ConflictResolved() when conflictResolved != null:
return conflictResolved(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SyncStarted value)  started,required TResult Function( SyncTriggered value)  triggered,required TResult Function( ConflictResolved value)  conflictResolved,}){
final _that = this;
switch (_that) {
case SyncStarted():
return started(_that);case SyncTriggered():
return triggered(_that);case ConflictResolved():
return conflictResolved(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SyncStarted value)?  started,TResult? Function( SyncTriggered value)?  triggered,TResult? Function( ConflictResolved value)?  conflictResolved,}){
final _that = this;
switch (_that) {
case SyncStarted() when started != null:
return started(_that);case SyncTriggered() when triggered != null:
return triggered(_that);case ConflictResolved() when conflictResolved != null:
return conflictResolved(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  triggered,TResult Function( SyncConflict conflict,  bool keepLocal)?  conflictResolved,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SyncStarted() when started != null:
return started();case SyncTriggered() when triggered != null:
return triggered();case ConflictResolved() when conflictResolved != null:
return conflictResolved(_that.conflict,_that.keepLocal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  triggered,required TResult Function( SyncConflict conflict,  bool keepLocal)  conflictResolved,}) {final _that = this;
switch (_that) {
case SyncStarted():
return started();case SyncTriggered():
return triggered();case ConflictResolved():
return conflictResolved(_that.conflict,_that.keepLocal);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  triggered,TResult? Function( SyncConflict conflict,  bool keepLocal)?  conflictResolved,}) {final _that = this;
switch (_that) {
case SyncStarted() when started != null:
return started();case SyncTriggered() when triggered != null:
return triggered();case ConflictResolved() when conflictResolved != null:
return conflictResolved(_that.conflict,_that.keepLocal);case _:
  return null;

}
}

}

/// @nodoc


class SyncStarted implements SyncEvent {
  const SyncStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncEvent.started()';
}


}




/// @nodoc


class SyncTriggered implements SyncEvent {
  const SyncTriggered();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncTriggered);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncEvent.triggered()';
}


}




/// @nodoc


class ConflictResolved implements SyncEvent {
  const ConflictResolved({required this.conflict, required this.keepLocal});
  

 final  SyncConflict conflict;
 final  bool keepLocal;

/// Create a copy of SyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConflictResolvedCopyWith<ConflictResolved> get copyWith => _$ConflictResolvedCopyWithImpl<ConflictResolved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConflictResolved&&(identical(other.conflict, conflict) || other.conflict == conflict)&&(identical(other.keepLocal, keepLocal) || other.keepLocal == keepLocal));
}


@override
int get hashCode => Object.hash(runtimeType,conflict,keepLocal);

@override
String toString() {
  return 'SyncEvent.conflictResolved(conflict: $conflict, keepLocal: $keepLocal)';
}


}

/// @nodoc
abstract mixin class $ConflictResolvedCopyWith<$Res> implements $SyncEventCopyWith<$Res> {
  factory $ConflictResolvedCopyWith(ConflictResolved value, $Res Function(ConflictResolved) _then) = _$ConflictResolvedCopyWithImpl;
@useResult
$Res call({
 SyncConflict conflict, bool keepLocal
});




}
/// @nodoc
class _$ConflictResolvedCopyWithImpl<$Res>
    implements $ConflictResolvedCopyWith<$Res> {
  _$ConflictResolvedCopyWithImpl(this._self, this._then);

  final ConflictResolved _self;
  final $Res Function(ConflictResolved) _then;

/// Create a copy of SyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? conflict = null,Object? keepLocal = null,}) {
  return _then(ConflictResolved(
conflict: null == conflict ? _self.conflict : conflict // ignore: cast_nullable_to_non_nullable
as SyncConflict,keepLocal: null == keepLocal ? _self.keepLocal : keepLocal // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
