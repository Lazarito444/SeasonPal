import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/backend_health.dart';
import 'connectivity_providers.dart';

/// Temporary Stage 0 landing screen: proves the Flutter client, build-time
/// config, and ASP.NET API talk to each other. Replaced by login/home in
/// Stage 2 without carrying any of this behavior forward.
class ConnectivityScreen extends ConsumerWidget {
  const ConnectivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(backendHealthProvider);
    final config = ref.watch(appConfigProvider);

    return Scaffold(
      body: Stack(
        children: [
          const _AmbientBackdrop(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _BrandMark(),
                      const SizedBox(height: 28),
                      Text(
                        'SeasonPal',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Cook with the season, keep what you love.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 36),
                      _ConnectionCard(
                        health: health,
                        apiBaseUrl: config.apiBaseUrl,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'DEVELOPMENT BUILD',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.charcoalMuted.withValues(
                            alpha: 0.75,
                          ),
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

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.sageMist,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sage.withValues(alpha: 0.55)),
      ),
      child: const Icon(Icons.eco_rounded, color: AppColors.forest, size: 24),
    );
  }
}

class _AmbientBackdrop extends StatelessWidget {
  const _AmbientBackdrop();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
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

class _ConnectionCard extends ConsumerWidget {
  const _ConnectionCard({required this.health, required this.apiBaseUrl});

  final AsyncValue<BackendHealth> health;
  final String apiBaseUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = _presentConnection(health);

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      decoration: BoxDecoration(
        color: AppColors.creamRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('BACKEND', style: Theme.of(context).textTheme.labelSmall),
              const Spacer(),
              _StatusPill(label: view.pill, tone: view.tone),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            view.title,
            key: const Key('connection-status'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(view.message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          Container(height: 1, color: AppColors.line),
          const SizedBox(height: 16),
          Text(
            'API ENDPOINT',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(letterSpacing: 1.3),
          ),
          const SizedBox(height: 6),
          Text(
            apiBaseUrl,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              height: 1.4,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            key: const Key('retry-button'),
            onPressed: health.isLoading
                ? null
                : () => ref.invalidate(backendHealthProvider),
            icon: health.isLoading
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded, size: 19),
            label: Text(health.isLoading ? 'Checking…' : 'Check again'),
          ),
        ],
      ),
    );
  }
}

typedef _ConnectionView = ({
  String pill,
  String title,
  String message,
  Color tone,
});

_ConnectionView _presentConnection(AsyncValue<BackendHealth> health) {
  if (health.isLoading) {
    return (
      pill: 'CHECKING',
      title: 'Checking the connection',
      message: 'Reaching the API and its database.',
      tone: AppColors.waiting,
    );
  }

  final value = health.value;
  if (health.hasError || value == null) {
    return (
      pill: 'OFFLINE',
      title: 'Health check failed',
      message: 'The check could not run. Try again in a moment.',
      tone: AppColors.offline,
    );
  }

  return switch (value.availability) {
    BackendAvailability.online => (
      pill: 'CONNECTED',
      title: 'Backend connected',
      message:
          'The API and database answered in ${_formatLatency(value.latency)}.',
      tone: AppColors.online,
    ),
    BackendAvailability.degraded => (
      pill: 'NOT READY',
      title: 'API is up, database is not',
      message:
          value.detail ?? 'The API answered, but its readiness check failed.',
      tone: AppColors.waiting,
    ),
    BackendAvailability.unreachable => (
      pill: 'OFFLINE',
      title: 'Backend unreachable',
      message:
          value.detail ?? 'Start the backend, then check the connection again.',
      tone: AppColors.offline,
    ),
  };
}

String _formatLatency(Duration latency) {
  if (latency.inMilliseconds < 1) return 'under a millisecond';
  if (latency.inMilliseconds < 1000) return '${latency.inMilliseconds} ms';
  return '${(latency.inMilliseconds / 1000).toStringAsFixed(1)} s';
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.tone});

  final String label;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Backend status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: tone.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: tone, shape: BoxShape.circle),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: tone,
                letterSpacing: 1.1,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
