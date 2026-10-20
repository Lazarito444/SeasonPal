import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The SeasonPal sprig mark. One shape reused across auth, onboarding and home.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 46});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.sageMist,
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(color: AppColors.sage.withValues(alpha: 0.55)),
      ),
      child: Icon(
        Icons.eco_rounded,
        color: AppColors.forest,
        size: size * 0.52,
      ),
    );
  }
}

/// Mark plus wordmark, used as the quiet header on auth screens.
class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BrandMark(size: 38),
        const SizedBox(width: 12),
        Text(
          'SeasonPal',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            letterSpacing: -0.4,
            color: AppColors.forest,
          ),
        ),
      ],
    );
  }
}
