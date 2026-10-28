import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/theme/app_theme.dart';

/// One answer group on the confirmation step: a titled card whose pencil jumps
/// back to the step that owns the answer.
class AppRecapCard extends StatelessWidget {
  const AppRecapCard({
    required this.title,
    required this.onEdit,
    required this.editLabel,
    required this.child,
    this.editKey,
    super.key,
  });

  final String title;
  final VoidCallback onEdit;
  final String editLabel;
  final Widget child;
  final Key? editKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 10, 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.line),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
              ),
              IconButton(
                key: editKey,
                onPressed: onEdit,
                tooltip: editLabel,
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceSunken,
                  foregroundColor: AppColors.forest,
                  minimumSize: const Size(36, 36),
                ),
                icon: const Icon(Icons.edit_rounded, size: 17),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: child,
          ),
        ],
      ),
    );
  }
}
