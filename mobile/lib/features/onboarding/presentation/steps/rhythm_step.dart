import 'package:flutter/material.dart';

import 'package:seasonpal/core/widgets/app_section_header.dart';
import 'package:seasonpal/core/widgets/app_select_card.dart';
import 'package:seasonpal/core/widgets/app_step_header.dart';
import 'package:seasonpal/features/onboarding/domain/onboarding_options.dart';
import 'package:seasonpal/features/onboarding/domain/user_preferences.dart';
import 'package:seasonpal/features/onboarding/presentation/onboarding_controller.dart';
import 'package:seasonpal/features/onboarding/presentation/onboarding_state.dart';
import 'package:seasonpal/features/onboarding/presentation/preference_labels.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Step 4: how confident the cook is, and how much time a normal night holds.
class RhythmStep extends StatelessWidget {
  const RhythmStep({
    required this.state,
    required this.controller,
    super.key,
  });

  final OnboardingState state;
  final OnboardingController controller;

  static const _skillIcons = {
    SkillLevel.beginner: Icons.flatware_rounded,
    SkillLevel.intermediate: Icons.restaurant_rounded,
    SkillLevel.advanced: Icons.science_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppStepHeader(
          eyebrow: t.onboarding.eyebrowRhythm(
            current: state.questionNumber,
            total: OnboardingState.questionCount,
          ),
          progress: state.progress,
          title: t.onboarding.rhythm.title,
          body: t.onboarding.rhythm.body,
        ),
        const SizedBox(height: 26),
        AppSectionHeader(
          icon: Icons.soup_kitchen_rounded,
          title: t.onboarding.rhythm.skillTitle,
          hint: t.onboarding.rhythm.skillHint,
        ),
        const SizedBox(height: 14),
        for (final level in SkillLevel.values) ...[
          AppSelectCard(
            key: Key('skill-${level.name}'),
            icon: _skillIcons[level] ?? Icons.restaurant_rounded,
            title: level.label(t),
            description: level.description(t),
            selected: state.skillLevel == level,
            onTap: () => controller.setSkillLevel(level),
            mode: AppSelectMode.single,
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 22),
        AppSectionHeader(
          icon: Icons.schedule_rounded,
          title: t.onboarding.rhythm.timeTitle,
          hint: t.onboarding.rhythm.timeHint,
        ),
        const SizedBox(height: 14),
        for (final bucket in OnboardingOptions.cookTimes) ...[
          AppSelectCard(
            key: Key('time-${bucket.id}'),
            icon: bucket.icon,
            title: cookTimeBucketLabel(t, bucket.id),
            description: cookTimeBucketDescription(t, bucket.id),
            selected: state.cookTimeBucketId == bucket.id,
            onTap: () => controller.toggleCookTimeBucket(bucket.id),
            mode: AppSelectMode.single,
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
