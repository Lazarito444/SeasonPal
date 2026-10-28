import 'package:flutter/foundation.dart';

import 'package:seasonpal/features/onboarding/domain/onboarding_options.dart';
import 'package:seasonpal/features/onboarding/domain/user_preferences.dart';

/// Local, unsaved wizard answers. The API only sees them on the final step.
@immutable
final class OnboardingState {
  const OnboardingState({
    this.step = 0,
    this.cuisines = const {},
    this.dietaryRestrictions = const {},
    this.skillLevel = SkillLevel.beginner,
    this.cookTimeBucketId,
    this.interests = const {},
    this.isSaving = false,
    this.error,
  });

  static const stepCount = 5;

  /// Steps that ask a question, in the order the progress meter counts them.
  static const cuisineStep = 1;
  static const dietStep = 2;
  static const rhythmStep = 3;
  static const recapStep = 4;

  /// Questions in the metered part of the wizard (welcome and recap excluded).
  static const questionCount = 3;

  final int step;
  final Set<String> cuisines;
  final Set<String> dietaryRestrictions;
  final SkillLevel skillLevel;
  final String? cookTimeBucketId;
  final Set<String> interests;
  final bool isSaving;
  final String? error;

  bool get isFirstStep => step == 0;

  bool get isLastStep => step == stepCount - 1;

  bool get hasStepHeader => step >= cuisineStep && step <= rhythmStep;

  /// 1-based position of the current question, for "STEP 2 OF 3".
  int get questionNumber => step.clamp(cuisineStep, questionCount);

  double get progress => questionNumber / questionCount;

  int get cuisinesRemaining => (OnboardingOptions.minimumCuisines - cuisines.length).clamp(0, OnboardingOptions.minimumCuisines);

  /// The design holds the first question until the feed has enough range.
  bool get canContinue => step != cuisineStep || cuisinesRemaining == 0;

  /// What the API stores: `null` when the answer is "it varies".
  int? get cookTimeMinutes {
    for (final bucket in OnboardingOptions.cookTimes) {
      if (bucket.id == cookTimeBucketId) {
        return bucket.minutes;
      }
    }

    return null;
  }

  OnboardingState copyWith({
    int? step,
    Set<String>? cuisines,
    Set<String>? dietaryRestrictions,
    SkillLevel? skillLevel,
    String? cookTimeBucketId,
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
      cookTimeBucketId: clearCookTime ? null : (cookTimeBucketId ?? this.cookTimeBucketId),
      interests: interests ?? this.interests,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
