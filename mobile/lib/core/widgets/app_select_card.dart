import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/theme/app_theme.dart';

/// How a card resolves its selected state. Multi-select commits with a forest
/// fill because several can be true at once; single-select stays light and
/// shows the choice in the trailing radio, so a single answer never shouts.
enum AppSelectMode { multiple, single }

/// Option card used by onboarding (and later profile editing): icon bubble,
/// title, one-line explanation, trailing check. Built to survive long copy —
/// both text lines clamp instead of pushing the card open.
class AppSelectCard extends StatelessWidget {
  const AppSelectCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
    this.mode = AppSelectMode.multiple,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;
  final AppSelectMode mode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filled = selected && mode == AppSelectMode.multiple;
    final tinted = selected && mode == AppSelectMode.single;

    final titleColor = filled
        ? AppColors.creamRaised
        : tinted
        ? AppColors.forest
        : AppColors.charcoal;
    final descriptionColor = filled ? AppColors.creamRaised.withValues(alpha: 0.82) : AppColors.charcoalMuted;

    return Semantics(
      button: true,
      selected: selected,
      label: '$title. $description',
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 170),
              curve: Curves.easeOut,
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
              decoration: BoxDecoration(
                color: filled
                    ? AppColors.forest
                    : tinted
                    ? AppColors.sageMist
                    : AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(
                  color: selected ? AppColors.forest : AppColors.line,
                  width: selected ? 1.5 : 1,
                ),
                boxShadow: filled || tinted ? AppShadows.card : null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? AppColors.creamRaised.withValues(alpha: 0.16)
                          : tinted
                          ? AppColors.forest.withValues(alpha: 0.1)
                          : AppColors.surfaceSunken,
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: filled ? AppColors.creamRaised : AppColors.forest,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: titleColor,
                          ),
                        ),
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: descriptionColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _SelectionDot(selected: selected, filled: filled),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionDot extends StatelessWidget {
  const _SelectionDot({required this.selected, required this.filled});

  final bool selected;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 170),
      width: 23,
      height: 23,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? (filled ? AppColors.creamRaised : AppColors.forest) : Colors.transparent,
        border: Border.all(
          color: selected ? Colors.transparent : AppColors.line,
          width: 1.5,
        ),
      ),
      child: selected
          ? Icon(
              Icons.check_rounded,
              size: 15,
              color: filled ? AppColors.forest : AppColors.creamRaised,
            )
          : null,
    );
  }
}
