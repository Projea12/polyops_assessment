// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncState {

 List<SyncConflict> get conflicts; bool get isSyncing; Set<String> get resolvingIds;
/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStateCopyWith<SyncState> get copyWith => _$SyncStateCopyWithImpl<SyncState>(this as SyncState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncState&&const DeepCollectionEquality().equals(other.conflicts, conflicts)&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&const DeepCollectionEquality().equals(other.resolvingIds, resolvingIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(conflicts),isSyncing,const DeepCollectionEquality().hash(resolvingIds));

@override
String toString() {
  return 'SyncState(conflicts: $conflicts, isSyncing: $isSyncing, resolvingIds: $resolvingIds)';
}


}

/// @nodoc
abstract mixin class $SyncStateCopyWith<$Res>  {
  factory $SyncStateCopyWith(SyncState value, $Res Function(SyncState) _then) = _$SyncStateCopyWithImpl;
@useResult
$Res call({
 List<SyncConflict> conflicts, bool isSyncing, Set<String> resolvingIds
});




}
/// @nodoc
class _$SyncStateCopyWithImpl<$Res>
    implements $SyncStateCopyWith<$Res> {
  _$SyncStateCopyWithImpl(this._self, this._then);

  final SyncState _self;
  final $Res Function(SyncState) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conflicts = null,Object? isSyncing = null,Object? resolvingIds = null,}) {
  return _then(_self.copyWith(
conflicts: null == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<SyncConflict>,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,resolvingIds: null == resolvingIds ? _self.resolvingIds : resolvingIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncState].
extension SyncStatePatterns on SyncState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncState value)  $default,){
final _that = this;
switch (_that) {
case _SyncState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncState value)?  $default,){
final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SyncConflict> conflicts,  bool isSyncing,  Set<String> resolvingIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that.conflicts,_that.isSyncing,_that.resolvingIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SyncConflict> conflicts,  bool isSyncing,  Set<String> resolvingIds)  $default,) {final _that = this;
switch (_that) {
case _SyncState():
return $default(_that.conflicts,_that.isSyncing,_that.resolvingIds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SyncConflict> conflicts,  bool isSyncing,  Set<String> resolvingIds)?  $default,) {final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that.conflicts,_that.isSyncing,_that.resolvingIds);case _:
  return null;

}
}

}

/// @nodoc


class _SyncState implements SyncState {
  const _SyncState({final  List<SyncConflict> conflicts = const <SyncConflict>[], this.isSyncing = false, final  Set<String> resolvingIds = const <String>{}}): _conflicts = conflicts,_resolvingIds = resolvingIds;
  

 final  List<SyncConflict> _conflicts;
@override@JsonKey() List<SyncConflict> get conflicts {
  if (_conflicts is EqualUnmodifiableListView) return _conflicts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conflicts);
}

@override@JsonKey() final  bool isSyncing;
 final  Set<String> _resolvingIds;
@override@JsonKey() Set<String> get resolvingIds {
  if (_resolvingIds is EqualUnmodifiableSetView) return _resolvingIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_resolvingIds);
}


/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncStateCopyWith<_SyncState> get copyWith => __$SyncStateCopyWithImpl<_SyncState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncState&&const DeepCollectionEquality().equals(other._conflicts, _conflicts)&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&const DeepCollectionEquality().equals(other._resolvingIds, _resolvingIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_conflicts),isSyncing,const DeepCollectionEquality().hash(_resolvingIds));

@override
String toString() {
  return 'SyncState(conflicts: $conflicts, isSyncing: $isSyncing, resolvingIds: $resolvingIds)';
}


}

/// @nodoc
abstract mixin class _$SyncStateCopyWith<$Res> implements $SyncStateCopyWith<$Res> {
  factory _$SyncStateCopyWith(_SyncState value, $Res Function(_SyncState) _then) = __$SyncStateCopyWithImpl;
@override @useResult
$Res call({
 List<SyncConflict> conflicts, bool isSyncing, Set<String> resolvingIds
});




}
/// @nodoc
class __$SyncStateCopyWithImpl<$Res>
    implements _$SyncStateCopyWith<$Res> {
  __$SyncStateCopyWithImpl(this._self, this._then);

  final _SyncState _self;
  final $Res Function(_SyncState) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conflicts = null,Object? isSyncing = null,Object? resolvingIds = null,}) {
  return _then(_SyncState(
conflicts: null == conflicts ? _self._conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<SyncConflict>,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,resolvingIds: null == resolvingIds ? _self._resolvingIds : resolvingIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
