import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';

/// Soft, out-of-focus colour fields behind the cream page; quiet enough to keep
/// food and type in front.
class AppBackdrop extends StatelessWidget {
  const AppBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -130,
            right: -100,
            child: _Glow(size: 340, color: AppColors.sage, opacity: 0.18),
          ),
          Positioned(
            bottom: -150,
            left: -120,
            child: _Glow(size: 300, color: AppColors.spice, opacity: 0.05),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color, required this.opacity});

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
