import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/app_backdrop.dart';
import 'package:seasonpal/core/widgets/brand_mark.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// A section that exists in the product map but has no working behaviour yet.
/// It says what is coming and never offers a control that does nothing.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.icon,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BrandLockup(),
                      const SizedBox(height: 56),
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: AppColors.sageMist,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(icon, color: AppColors.forest, size: 28),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        eyebrow.toUpperCase(),
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: AppColors.spice),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 14),
                      Text(body, style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.creamRaised,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Text(
                          t.comingSoon.badge,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.charcoalMuted),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
