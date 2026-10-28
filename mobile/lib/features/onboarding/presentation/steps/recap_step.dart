import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/app_recap_card.dart';
import 'package:seasonpal/features/onboarding/presentation/onboarding_controller.dart';
import 'package:seasonpal/features/onboarding/presentation/onboarding_state.dart';
import 'package:seasonpal/features/onboarding/presentation/preference_labels.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Step 5: everything the wizard collected, each group with a pencil back to
/// the question that owns it.
class RecapStep extends StatelessWidget {
  const RecapStep({
    required this.state,
    required this.controller,
    super.key,
  });

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final edit = t.onboarding.done.editSection;

    final cuisines = state.cuisines.map((value) => cuisineLabel(t, value)).toList(growable: false);
    final diets = state.dietaryRestrictions.map((value) => dietLabel(t, value)).toList(growable: false);
    final interests = state.interests.map((value) => interestLabel(t, value)).toList(growable: false);
    final bucketId = state.cookTimeBucketId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 6),
        const Center(child: _SprigBadge()),
        const SizedBox(height: 22),
        Text(
          t.onboarding.done.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineLarge,
        ),
        const SizedBox(height: 10),
        Text(
          t.onboarding.done.body,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 26),
        AppRecapCard(
          editKey: const Key('recap-edit-cuisines'),
          title: t.onboarding.done.cuisinesTitle(count: cuisines.length),
          onEdit: () => controller.jumpTo(OnboardingState.cuisineStep),
          editLabel: edit,
          child: cuisines.isEmpty
              ? Text(
                  t.onboarding.done.emptyCuisines,
                  style: theme.textTheme.bodyMedium,
                )
              : Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    for (final cuisine in cuisines) _RecapPill(label: cuisine),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        AppRecapCard(
          editKey: const Key('recap-edit-diet'),
          title: t.onboarding.done.dietTitle,
          onEdit: () => controller.jumpTo(OnboardingState.dietStep),
          editLabel: edit,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LabeledLine(
                label: t.onboarding.done.dietLabel,
                value: diets.isEmpty ? t.onboarding.done.emptyDiet : diets.join(', '),
              ),
              const SizedBox(height: 10),
              _LabeledLine(
                label: t.onboarding.done.interestsLabel,
                value: interests.isEmpty ? t.onboarding.done.emptyInterests : interests.join(', '),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppRecapCard(
          editKey: const Key('recap-edit-rhythm'),
          title: t.onboarding.done.rhythmTitle,
          onEdit: () => controller.jumpTo(OnboardingState.rhythmStep),
          editLabel: edit,
          child: Wrap(
            spacing: 18,
            runSpacing: 10,
            children: [
              _Metric(
                icon: Icons.soup_kitchen_rounded,
                label: state.skillLevel.label(t),
              ),
              _Metric(
                icon: Icons.schedule_rounded,
                label: bucketId == null ? t.onboarding.done.noTime : cookTimeBucketLabel(t, bucketId),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SprigBadge extends StatelessWidget {
  const _SprigBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      height: 92,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.sageMist.withValues(alpha: 0.75),
            ),
          ),
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.sage.withValues(alpha: 0.7),
              ),
            ),
          ),
          const Icon(Icons.eco_rounded, size: 34, color: AppColors.forest),
          Positioned(
            bottom: 18,
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: AppColors.forest,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 14,
                color: AppColors.creamRaised,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecapPill extends StatelessWidget {
  const _RecapPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.sageMist,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.forest,
            ),
          ),
          const SizedBox(width: 6),
          // Flexible so a long cuisine name shrinks inside the pill instead of
          // overflowing the recap card on a narrow phone.
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.forest,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledLine extends StatelessWidget {
  const _LabeledLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 84,
          child: Text(label, style: theme.textTheme.labelSmall),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.charcoal,
            ),
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: AppColors.spice),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.charcoal,
            ),
          ),
        ),
      ],
    );
  }
}
