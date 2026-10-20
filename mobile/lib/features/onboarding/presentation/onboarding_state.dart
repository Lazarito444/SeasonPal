import 'package:flutter/foundation.dart';

import 'package:seasonpal/features/onboarding/domain/user_preferences.dart';

/// Local, unsaved wizard answers. The API only sees them on the final step.
@immutable
final class OnboardingState {
  const OnboardingState({
    this.step = 0,
    this.cuisines = const {},
    this.dietaryRestrictions = const {},
    this.skillLevel = SkillLevel.beginner,
    this.cookTimeMinutes,
    this.interests = const {},
    this.isSaving = false,
    this.error,
  });

  static const stepCount = 5;

  final int step;
  final Set<String> cuisines;
  final Set<String> dietaryRestrictions;
  final SkillLevel skillLevel;
  final int? cookTimeMinutes;
  final Set<String> interests;
  final bool isSaving;
  final String? error;

  bool get isFirstStep => step == 0;

  bool get isLastStep => step == stepCount - 1;

  OnboardingState copyWith({
    int? step,
    Set<String>? cuisines,
    Set<String>? dietaryRestrictions,
    SkillLevel? skillLevel,
    int? cookTimeMinutes,
    bool clearCookTime = false,
    Set<String>? interests,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      cuisines: cuisines ?? this.cuisines,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      skillLevel: skillLevel ?? this.skillLevel,
      cookTimeMinutes: clearCookTime ? null : (cookTimeMinutes ?? this.cookTimeMinutes),
      interests: interests ?? this.interests,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
