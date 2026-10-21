import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';

/// Food photography with a warm, quiet fallback. Keeps every surface honest
/// when a recipe has no cover yet and never shows a broken-image glyph.
class RemotePhoto extends StatelessWidget {
  const RemotePhoto({
    required this.url,
    this.fit = BoxFit.cover,
    this.iconSize = 30,
    this.semanticLabel,
    super.key,
  });

  final String? url;
  final BoxFit fit;
  final double iconSize;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final location = url?.trim();
    if (location == null || location.isEmpty) {
      return _PhotoFallback(iconSize: iconSize);
    }

    return Image.network(
      location,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      semanticLabel: semanticLabel,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }

        return const _PhotoPlaceholder(showProgress: true);
      },
      errorBuilder: (context, error, stackTrace) => _PhotoFallback(
        iconSize: iconSize,
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({required this.showProgress});

  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.sageMist,
      child: Center(
        child: showProgress
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.forest,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback({required this.iconSize});

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.sageMist, AppColors.creamRaised],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_rounded,
          size: iconSize,
          color: AppColors.forest.withValues(alpha: 0.28),
        ),
      ),
    );
  }
}
