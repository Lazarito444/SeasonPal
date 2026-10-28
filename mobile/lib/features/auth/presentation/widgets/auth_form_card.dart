import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/theme/app_theme.dart';

/// Stoneware card that holds the login form. A faint leaf sits in the top-right
/// corner, echoing the exported design without competing with the fields.
class AuthFormCard extends StatelessWidget {
  const AuthFormCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.line),
        boxShadow: AppShadows.lifted,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: Stack(
          children: [
            Positioned(
              top: -34,
              right: -30,
              child: Icon(
                Icons.eco_rounded,
                size: 150,
                color: AppColors.forest.withValues(alpha: 0.035),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
