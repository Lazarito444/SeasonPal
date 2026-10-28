import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/theme/app_theme.dart';

/// Step heading for the onboarding wizard: a tracked eyebrow line, the progress
/// meter for the whole wizard, then the step's display title and lead line.
class AppStepHeader extends StatelessWidget {
  const AppStepHeader({
    required this.eyebrow,
    required this.progress,
    required this.title,
    required this.body,
    super.key,
  });

  final String eyebrow;

  /// 0–1. Drives the meter below the eyebrow.
  final double progress;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.charcoalMuted,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          child: Container(
            height: 4,
            color: AppColors.line,
            alignment: Alignment.centerLeft,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress.clamp(0, 1)),
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => FractionallySizedBox(
                widthFactor: value,
                child: Container(color: AppColors.forest),
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(title, style: theme.textTheme.headlineLarge),
        const SizedBox(height: 10),
        Text(body, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}
