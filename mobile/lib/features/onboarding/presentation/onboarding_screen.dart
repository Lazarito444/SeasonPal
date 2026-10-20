import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_backdrop.dart';
import '../../../core/widgets/app_choice_chip.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../i18n/strings.g.dart';
import '../domain/onboarding_options.dart';
import '../domain/user_preferences.dart';
import 'onboarding_controller.dart';
import 'onboarding_state.dart';
import 'preference_labels.dart';

/// Five quiet steps: welcome, cuisines, diet (plus interests), rhythm, done.
/// Answers stay local until the final step saves them.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  children: [
                    _WizardHeader(
                      step: state.step,
                      onBack: state.isFirstStep ? null : controller.back,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        key: ValueKey(state.step),
                        padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
                        child: _StepBody(state: state, controller: controller),
                      ),
                    ),
                    _WizardFooter(state: state, controller: controller),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WizardHeader extends StatelessWidget {
  const _WizardHeader({required this.step, this.onBack});

  final int step;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 24, 0),
      child: Column(
        children: [
          Row(
            children: [
              if (onBack == null)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: BrandMark(size: 34),
                )
              else
                IconButton(
                  key: const Key('onboarding-back-top'),
                  onPressed: onBack,
                  tooltip: t.common.back,
                  icon: const Icon(Icons.arrow_back_rounded, size: 21),
                ),
              const Spacer(),
              Text(
                t.onboarding.stepIndicator(
                  current: step + 1,
                  total: OnboardingState.stepCount,
                ),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (
                var index = 0;
                index < OnboardingState.stepCount;
                index++
              ) ...[
                if (index > 0) const SizedBox(width: 6),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= step ? AppColors.forest : AppColors.line,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StepBody extends StatelessWidget {
  const _StepBody({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return switch (state.step) {
      0 => const _WelcomeStep(),
      1 => _CuisinesStep(state: state, controller: controller),
      2 => _DietStep(state: state, controller: controller),
      3 => _RhythmStep(state: state, controller: controller),
      _ => _DoneStep(state: state),
    };
  }
}

class _StepHeading extends StatelessWidget {
  const _StepHeading({
    required this.eyebrow,
    required this.title,
    required this.body,
  });

  final String eyebrow;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.spice),
        ),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(body, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          t.onboarding.welcome.eyebrow,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.spice),
        ),
        const SizedBox(height: 12),
        Text(
          t.onboarding.welcome.title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 14),
        Text(
          t.onboarding.welcome.body,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 34),
        _Note(
          icon: Icons.public_rounded,
          title: t.onboarding.welcome.cuisineTitle,
          body: t.onboarding.welcome.cuisineBody,
        ),
        _Note(
          icon: Icons.no_food_outlined,
          title: t.onboarding.welcome.dietTitle,
          body: t.onboarding.welcome.dietBody,
        ),
        _Note(
          icon: Icons.schedule_rounded,
          title: t.onboarding.welcome.timeTitle,
          body: t.onboarding.welcome.timeBody,
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: AppColors.sageMist.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.timelapse_rounded,
                size: 17,
                color: AppColors.forest,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  t.onboarding.welcome.duration,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.forest,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.creamRaised,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
            ),
            child: Icon(icon, size: 20, color: AppColors.forest),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CuisinesStep extends StatelessWidget {
  const _CuisinesStep({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeading(
          eyebrow: t.onboarding.cuisines.eyebrow,
          title: t.onboarding.cuisines.title,
          body: t.onboarding.cuisines.body,
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final cuisine in OnboardingOptions.cuisines)
              AppChoiceChip(
                key: Key('cuisine-$cuisine'),
                label: cuisineLabel(t, cuisine),
                selected: state.cuisines.contains(cuisine),
                onTap: () => controller.toggleCuisine(cuisine),
              ),
          ],
        ),
      ],
    );
  }
}

class _DietStep extends StatelessWidget {
  const _DietStep({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeading(
          eyebrow: t.onboarding.diet.eyebrow,
          title: t.onboarding.diet.title,
          body: t.onboarding.diet.body,
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final restriction in OnboardingOptions.dietaryRestrictions)
              AppChoiceChip(
                key: Key('diet-$restriction'),
                label: dietLabel(t, restriction),
                selected: state.dietaryRestrictions.contains(restriction),
                onTap: () => controller.toggleDietaryRestriction(restriction),
              ),
          ],
        ),
        const SizedBox(height: 34),
        Container(height: 1, color: AppColors.line),
        const SizedBox(height: 26),
        Text(
          t.onboarding.diet.interestsTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          t.onboarding.diet.interestsBody,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final interest in OnboardingOptions.interests)
              AppChoiceChip(
                key: Key('interest-$interest'),
                label: interestLabel(t, interest),
                selected: state.interests.contains(interest),
                onTap: () => controller.toggleInterest(interest),
              ),
          ],
        ),
      ],
    );
  }
}

class _RhythmStep extends StatelessWidget {
  const _RhythmStep({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeading(
          eyebrow: t.onboarding.rhythm.eyebrow,
          title: t.onboarding.rhythm.title,
          body: t.onboarding.rhythm.body,
        ),
        const SizedBox(height: 22),
        for (final level in SkillLevel.values) ...[
          _SkillOption(
            key: Key('skill-${level.name}'),
            level: level,
            selected: state.skillLevel == level,
            onTap: () => controller.setSkillLevel(level),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 22),
        Text(
          t.onboarding.rhythm.timeTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          t.onboarding.rhythm.timeBody,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final minutes in OnboardingOptions.cookTimes)
              AppChoiceChip(
                key: Key('time-$minutes'),
                label: cookTimeLabel(t, minutes),
                selected: state.cookTimeMinutes == minutes,
                onTap: () => controller.toggleCookTime(minutes),
              ),
          ],
        ),
      ],
    );
  }
}

class _SkillOption extends StatelessWidget {
  const _SkillOption({
    required this.level,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final SkillLevel level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Semantics(
      button: true,
      selected: selected,
      label: '${level.label(t)}. ${level.description(t)}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected ? AppColors.sageMist : AppColors.creamRaised,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? AppColors.forest : AppColors.line,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 21,
                  height: 21,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.forest : Colors.transparent,
                    border: Border.all(
                      color: selected ? AppColors.forest : AppColors.line,
                      width: 1.5,
                    ),
                  ),
                  child: selected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: AppColors.creamRaised,
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level.label(t),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        level.description(t),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DoneStep extends StatelessWidget {
  const _DoneStep({required this.state});

  final OnboardingState state;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final cuisines = state.cuisines.isEmpty
        ? t.onboarding.done.openToAnything
        : state.cuisines.map((value) => cuisineLabel(t, value)).join(', ');
    final diet = state.dietaryRestrictions.isEmpty
        ? t.onboarding.done.noRestrictions
        : state.dietaryRestrictions
              .map((value) => dietLabel(t, value))
              .join(', ');
    final time = state.cookTimeMinutes == null
        ? t.onboarding.done.noTime
        : cookTimeLabel(t, state.cookTimeMinutes!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: AppColors.sageMist,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 26,
            color: AppColors.forest,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          t.onboarding.done.title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        Text(
          t.onboarding.done.body,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.creamRaised,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: [
              _SummaryRow(
                label: t.onboarding.done.summaryCuisines,
                value: cuisines,
              ),
              _SummaryRow(label: t.onboarding.done.summaryDiet, value: diet),
              _SummaryRow(
                label: t.onboarding.done.summarySkill,
                value: state.skillLevel.label(t),
              ),
              _SummaryRow(
                label: t.onboarding.done.summaryTime,
                value: time,
                isLast: true,
              ),
            ],
          ),
        ),
        if (state.interests.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            t.onboarding.done.alsoInto,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.spice),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final interest in state.interests)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.sageMist.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    interestLabel(t, interest),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.forest),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontSize: 10),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 15,
                color: AppColors.charcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WizardFooter extends StatelessWidget {
  const _WizardFooter({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final isLast = state.isLastStep;
    final label = state.isFirstStep
        ? t.onboarding.footer.begin
        : isLast
        ? t.onboarding.footer.finish
        : t.onboarding.footer.next;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.94),
        border: const Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.error != null) ...[
            ErrorBanner(message: state.error!),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              if (!state.isFirstStep) ...[
                TextButton(
                  key: const Key('onboarding-back'),
                  onPressed: state.isSaving ? null : controller.back,
                  child: Text(t.common.back),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: FilledButton(
                  key: const Key('onboarding-primary'),
                  onPressed: state.isSaving
                      ? null
                      : () {
                          if (isLast) {
                            controller.finish();
                          } else {
                            controller.next();
                          }
                        },
                  child: state.isSaving
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 10),
                            Text(t.onboarding.footer.saving),
                          ],
                        )
                      : Text(label),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
