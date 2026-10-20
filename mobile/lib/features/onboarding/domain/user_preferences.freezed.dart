// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserPreferences {

 List<String> get favoriteCuisines; List<String> get dietaryRestrictions; SkillLevel get skillLevel; int? get usualCookTimeMinutes; List<String> get interests; bool get onboardingCompleted; DateTime? get completedAt;
/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<UserPreferences> get copyWith => _$UserPreferencesCopyWithImpl<UserPreferences>(this as UserPreferences, _$identity);

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPreferences&&const DeepCollectionEquality().equals(other.favoriteCuisines, favoriteCuisines)&&const DeepCollectionEquality().equals(other.dietaryRestrictions, dietaryRestrictions)&&(identical(other.skillLevel, skillLevel) || other.skillLevel == skillLevel)&&(identical(other.usualCookTimeMinutes, usualCookTimeMinutes) || other.usualCookTimeMinutes == usualCookTimeMinutes)&&const DeepCollectionEquality().equals(other.interests, interests)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(favoriteCuisines),const DeepCollectionEquality().hash(dietaryRestrictions),skillLevel,usualCookTimeMinutes,const DeepCollectionEquality().hash(interests),onboardingCompleted,completedAt);

@override
String toString() {
  return 'UserPreferences(favoriteCuisines: $favoriteCuisines, dietaryRestrictions: $dietaryRestrictions, skillLevel: $skillLevel, usualCookTimeMinutes: $usualCookTimeMinutes, interests: $interests, onboardingCompleted: $onboardingCompleted, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $UserPreferencesCopyWith<$Res>  {
  factory $UserPreferencesCopyWith(UserPreferences value, $Res Function(UserPreferences) _then) = _$UserPreferencesCopyWithImpl;
@useResult
$Res call({
 List<String> favoriteCuisines, List<String> dietaryRestrictions, SkillLevel skillLevel, int? usualCookTimeMinutes, List<String> interests, bool onboardingCompleted, DateTime? completedAt
});




}
/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._self, this._then);

  final UserPreferences _self;
  final $Res Function(UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? favoriteCuisines = null,Object? dietaryRestrictions = null,Object? skillLevel = null,Object? usualCookTimeMinutes = freezed,Object? interests = null,Object? onboardingCompleted = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
favoriteCuisines: null == favoriteCuisines ? _self.favoriteCuisines : favoriteCuisines // ignore: cast_nullable_to_non_nullable
as List<String>,dietaryRestrictions: null == dietaryRestrictions ? _self.dietaryRestrictions : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
as List<String>,skillLevel: null == skillLevel ? _self.skillLevel : skillLevel // ignore: cast_nullable_to_non_nullable
as SkillLevel,usualCookTimeMinutes: freezed == usualCookTimeMinutes ? _self.usualCookTimeMinutes : usualCookTimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPreferences].
extension UserPreferencesPatterns on UserPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPreferences value)  $default,){
final _that = this;
switch (_that) {
case _UserPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> favoriteCuisines,  List<String> dietaryRestrictions,  SkillLevel skillLevel,  int? usualCookTimeMinutes,  List<String> interests,  bool onboardingCompleted,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.favoriteCuisines,_that.dietaryRestrictions,_that.skillLevel,_that.usualCookTimeMinutes,_that.interests,_that.onboardingCompleted,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> favoriteCuisines,  List<String> dietaryRestrictions,  SkillLevel skillLevel,  int? usualCookTimeMinutes,  List<String> interests,  bool onboardingCompleted,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _UserPreferences():
return $default(_that.favoriteCuisines,_that.dietaryRestrictions,_that.skillLevel,_that.usualCookTimeMinutes,_that.interests,_that.onboardingCompleted,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> favoriteCuisines,  List<String> dietaryRestrictions,  SkillLevel skillLevel,  int? usualCookTimeMinutes,  List<String> interests,  bool onboardingCompleted,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.favoriteCuisines,_that.dietaryRestrictions,_that.skillLevel,_that.usualCookTimeMinutes,_that.interests,_that.onboardingCompleted,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserPreferences implements UserPreferences {
  const _UserPreferences({final  List<String> favoriteCuisines = const [], final  List<String> dietaryRestrictions = const [], this.skillLevel = SkillLevel.beginner, this.usualCookTimeMinutes, final  List<String> interests = const [], this.onboardingCompleted = false, this.completedAt}): _favoriteCuisines = favoriteCuisines,_dietaryRestrictions = dietaryRestrictions,_interests = interests;
  factory _UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);

 final  List<String> _favoriteCuisines;
@override@JsonKey() List<String> get favoriteCuisines {
  if (_favoriteCuisines is EqualUnmodifiableListView) return _favoriteCuisines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteCuisines);
}

 final  List<String> _dietaryRestrictions;
@override@JsonKey() List<String> get dietaryRestrictions {
  if (_dietaryRestrictions is EqualUnmodifiableListView) return _dietaryRestrictions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dietaryRestrictions);
}

@override@JsonKey() final  SkillLevel skillLevel;
@override final  int? usualCookTimeMinutes;
 final  List<String> _interests;
@override@JsonKey() List<String> get interests {
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interests);
}

@override@JsonKey() final  bool onboardingCompleted;
@override final  DateTime? completedAt;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPreferencesCopyWith<_UserPreferences> get copyWith => __$UserPreferencesCopyWithImpl<_UserPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPreferences&&const DeepCollectionEquality().equals(other._favoriteCuisines, _favoriteCuisines)&&const DeepCollectionEquality().equals(other._dietaryRestrictions, _dietaryRestrictions)&&(identical(other.skillLevel, skillLevel) || other.skillLevel == skillLevel)&&(identical(other.usualCookTimeMinutes, usualCookTimeMinutes) || other.usualCookTimeMinutes == usualCookTimeMinutes)&&const DeepCollectionEquality().equals(other._interests, _interests)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_favoriteCuisines),const DeepCollectionEquality().hash(_dietaryRestrictions),skillLevel,usualCookTimeMinutes,const DeepCollectionEquality().hash(_interests),onboardingCompleted,completedAt);

@override
String toString() {
  return 'UserPreferences(favoriteCuisines: $favoriteCuisines, dietaryRestrictions: $dietaryRestrictions, skillLevel: $skillLevel, usualCookTimeMinutes: $usualCookTimeMinutes, interests: $interests, onboardingCompleted: $onboardingCompleted, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$UserPreferencesCopyWith<$Res> implements $UserPreferencesCopyWith<$Res> {
  factory _$UserPreferencesCopyWith(_UserPreferences value, $Res Function(_UserPreferences) _then) = __$UserPreferencesCopyWithImpl;
@override @useResult
$Res call({
 List<String> favoriteCuisines, List<String> dietaryRestrictions, SkillLevel skillLevel, int? usualCookTimeMinutes, List<String> interests, bool onboardingCompleted, DateTime? completedAt
});




}
/// @nodoc
class __$UserPreferencesCopyWithImpl<$Res>
    implements _$UserPreferencesCopyWith<$Res> {
  __$UserPreferencesCopyWithImpl(this._self, this._then);

  final _UserPreferences _self;
  final $Res Function(_UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? favoriteCuisines = null,Object? dietaryRestrictions = null,Object? skillLevel = null,Object? usualCookTimeMinutes = freezed,Object? interests = null,Object? onboardingCompleted = null,Object? completedAt = freezed,}) {
  return _then(_UserPreferences(
favoriteCuisines: null == favoriteCuisines ? _self._favoriteCuisines : favoriteCuisines // ignore: cast_nullable_to_non_nullable
as List<String>,dietaryRestrictions: null == dietaryRestrictions ? _self._dietaryRestrictions : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
as List<String>,skillLevel: null == skillLevel ? _self.skillLevel : skillLevel // ignore: cast_nullable_to_non_nullable
as SkillLevel,usualCookTimeMinutes: freezed == usualCookTimeMinutes ? _self.usualCookTimeMinutes : usualCookTimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
