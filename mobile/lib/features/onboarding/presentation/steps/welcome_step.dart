import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/theme/app_theme.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Step 1: what the wizard will ask for, and what it is for.
class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 86,
            height: 86,
            decoration: const BoxDecoration(
              color: AppColors.sageMist,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco_rounded,
              size: 38,
              color: AppColors.forest,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          t.onboarding.welcome.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineLarge,
        ),
        const SizedBox(height: 10),
        Text(
          t.onboarding.welcome.body,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 30),
        Text(
          t.onboarding.welcome.itineraryTitle,
          style: theme.textTheme.labelSmall,
        ),
        const SizedBox(height: 10),
        _ItineraryTile(
          index: 1,
          icon: Icons.public_rounded,
          title: t.onboarding.welcome.cuisineTitle,
          body: t.onboarding.welcome.cuisineBody,
        ),
        const SizedBox(height: 10),
        _ItineraryTile(
          index: 2,
          icon: Icons.local_florist_rounded,
          title: t.onboarding.welcome.dietTitle,
          body: t.onboarding.welcome.dietBody,
        ),
        const SizedBox(height: 10),
        _ItineraryTile(
          index: 3,
          icon: Icons.schedule_rounded,
          title: t.onboarding.welcome.rhythmTitle,
          body: t.onboarding.welcome.rhythmBody,
        ),
      ],
    );
  }
}

class _ItineraryTile extends StatelessWidget {
  const _ItineraryTile({
    required this.index,
    required this.icon,
    required this.title,
    required this.body,
  });

  final int index;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.line),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surfaceSunken,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.forest,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 17, color: AppColors.spice),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(title, style: theme.textTheme.titleMedium),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(body, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
