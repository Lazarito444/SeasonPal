// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    _UserPreferences(
      favoriteCuisines:
          (json['favoriteCuisines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dietaryRestrictions:
          (json['dietaryRestrictions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      skillLevel:
          $enumDecodeNullable(_$SkillLevelEnumMap, json['skillLevel']) ??
          SkillLevel.beginner,
      usualCookTimeMinutes: (json['usualCookTimeMinutes'] as num?)?.toInt(),
      interests:
          (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$UserPreferencesToJson(_UserPreferences instance) =>
    <String, dynamic>{
      'favoriteCuisines': instance.favoriteCuisines,
      'dietaryRestrictions': instance.dietaryRestrictions,
      'skillLevel': _$SkillLevelEnumMap[instance.skillLevel]!,
      'usualCookTimeMinutes': instance.usualCookTimeMinutes,
      'interests': instance.interests,
      'onboardingCompleted': instance.onboardingCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$SkillLevelEnumMap = {
  SkillLevel.beginner: 0,
  SkillLevel.intermediate: 1,
  SkillLevel.advanced: 2,
};
