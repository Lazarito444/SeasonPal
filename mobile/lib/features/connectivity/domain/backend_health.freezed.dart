// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backend_health.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackendHealth {

 BackendAvailability get availability; DateTime get checkedAt; Duration get latency; int? get statusCode; String? get detail;
/// Create a copy of BackendHealth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackendHealthCopyWith<BackendHealth> get copyWith => _$BackendHealthCopyWithImpl<BackendHealth>(this as BackendHealth, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackendHealth&&(identical(other.availability, availability) || other.availability == availability)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.latency, latency) || other.latency == latency)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,availability,checkedAt,latency,statusCode,detail);

@override
String toString() {
  return 'BackendHealth(availability: $availability, checkedAt: $checkedAt, latency: $latency, statusCode: $statusCode, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $BackendHealthCopyWith<$Res>  {
  factory $BackendHealthCopyWith(BackendHealth value, $Res Function(BackendHealth) _then) = _$BackendHealthCopyWithImpl;
@useResult
$Res call({
 BackendAvailability availability, DateTime checkedAt, Duration latency, int? statusCode, String? detail
});




}
/// @nodoc
class _$BackendHealthCopyWithImpl<$Res>
    implements $BackendHealthCopyWith<$Res> {
  _$BackendHealthCopyWithImpl(this._self, this._then);

  final BackendHealth _self;
  final $Res Function(BackendHealth) _then;

/// Create a copy of BackendHealth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? availability = null,Object? checkedAt = null,Object? latency = null,Object? statusCode = freezed,Object? detail = freezed,}) {
  return _then(_self.copyWith(
availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as BackendAvailability,checkedAt: null == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as Duration,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BackendHealth].
extension BackendHealthPatterns on BackendHealth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackendHealth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackendHealth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackendHealth value)  $default,){
final _that = this;
switch (_that) {
case _BackendHealth():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackendHealth value)?  $default,){
final _that = this;
switch (_that) {
case _BackendHealth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BackendAvailability availability,  DateTime checkedAt,  Duration latency,  int? statusCode,  String? detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackendHealth() when $default != null:
return $default(_that.availability,_that.checkedAt,_that.latency,_that.statusCode,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BackendAvailability availability,  DateTime checkedAt,  Duration latency,  int? statusCode,  String? detail)  $default,) {final _that = this;
switch (_that) {
case _BackendHealth():
return $default(_that.availability,_that.checkedAt,_that.latency,_that.statusCode,_that.detail);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BackendAvailability availability,  DateTime checkedAt,  Duration latency,  int? statusCode,  String? detail)?  $default,) {final _that = this;
switch (_that) {
case _BackendHealth() when $default != null:
return $default(_that.availability,_that.checkedAt,_that.latency,_that.statusCode,_that.detail);case _:
  return null;

}
}

}

/// @nodoc


class _BackendHealth extends BackendHealth {
  const _BackendHealth({required this.availability, required this.checkedAt, required this.latency, this.statusCode, this.detail}): super._();
  

@override final  BackendAvailability availability;
@override final  DateTime checkedAt;
@override final  Duration latency;
@override final  int? statusCode;
@override final  String? detail;

/// Create a copy of BackendHealth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackendHealthCopyWith<_BackendHealth> get copyWith => __$BackendHealthCopyWithImpl<_BackendHealth>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackendHealth&&(identical(other.availability, availability) || other.availability == availability)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.latency, latency) || other.latency == latency)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,availability,checkedAt,latency,statusCode,detail);

@override
String toString() {
  return 'BackendHealth(availability: $availability, checkedAt: $checkedAt, latency: $latency, statusCode: $statusCode, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$BackendHealthCopyWith<$Res> implements $BackendHealthCopyWith<$Res> {
  factory _$BackendHealthCopyWith(_BackendHealth value, $Res Function(_BackendHealth) _then) = __$BackendHealthCopyWithImpl;
@override @useResult
$Res call({
 BackendAvailability availability, DateTime checkedAt, Duration latency, int? statusCode, String? detail
});




}
/// @nodoc
class __$BackendHealthCopyWithImpl<$Res>
    implements _$BackendHealthCopyWith<$Res> {
  __$BackendHealthCopyWithImpl(this._self, this._then);

  final _BackendHealth _self;
  final $Res Function(_BackendHealth) _then;

/// Create a copy of BackendHealth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? availability = null,Object? checkedAt = null,Object? latency = null,Object? statusCode = freezed,Object? detail = freezed,}) {
  return _then(_BackendHealth(
availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as BackendAvailability,checkedAt: null == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as Duration,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
