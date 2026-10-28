import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';

/// Heading for a group of options inside a longer step ("Dietary
/// restrictions", "Time you usually cook"), with a short instruction line.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.icon,
    required this.title,
    this.hint,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 19, color: AppColors.spice),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title, style: theme.textTheme.titleLarge),
            ),
          ],
        ),
        if (hint != null) ...[
          const SizedBox(height: 4),
          Text(hint!, style: theme.textTheme.bodyMedium),
        ],
      ],
    );
  }
}
