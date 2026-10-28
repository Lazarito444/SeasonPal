import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/theme/app_theme.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Four-segment password meter for registration. The score mirrors the server
/// policy (length, mixed case, digit, symbol) so the meter, the inline rules and
/// the validator never disagree.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({required this.password, super.key});

  final String password;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final score = passwordStrengthScore(password);

    final (String caption, Color color) = switch (score) {
      1 => (t.auth.register.strengthWeak, AppColors.spice),
      2 => (t.auth.register.strengthFair, AppColors.waiting),
      3 => (t.auth.register.strengthGood, AppColors.forest),
      4 => (t.auth.register.strengthStrong, AppColors.forest),
      _ => (t.auth.register.strengthEmpty, AppColors.charcoalMuted),
    };
    final segmentColor = switch (score) {
      1 => AppColors.spice,
      2 => AppColors.waiting,
      3 => AppColors.sage,
      _ => AppColors.forest,
    };
    final label = score == 0 ? caption : '${t.auth.register.strengthLabel} · $caption';

    return Semantics(
      liveRegion: true,
      label: label,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var index = 0; index < 4; index++) ...[
                if (index > 0) const SizedBox(width: 6),
                Expanded(
                  child: AnimatedContainer(
                    key: ValueKey('strength-segment-$index'),
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    height: 5,
                    decoration: BoxDecoration(
                      color: index < score ? segmentColor : AppColors.line.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: score == 0 ? AppColors.charcoalMuted : color,
              fontWeight: score == 0 ? FontWeight.w400 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// 0–4: meets the length rule, then mixed case, a digit and a symbol.
int passwordStrengthScore(String value) {
  if (value.isEmpty) {
    return 0;
  }

  var score = 0;
  if (value.length >= 8) {
    score += 1;
  }

  final hasUpper = RegExp(r'\p{Lu}', unicode: true).hasMatch(value);
  final hasLower = RegExp(r'\p{Ll}', unicode: true).hasMatch(value);
  if (hasUpper && hasLower) {
    score += 1;
  }

  if (RegExp(r'\p{Nd}', unicode: true).hasMatch(value)) {
    score += 1;
  }

  if (RegExp(r'[^\p{L}\p{N}]', unicode: true).hasMatch(value)) {
    score += 1;
  }

  return score;
}
