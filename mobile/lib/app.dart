import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Root widget; reads the router from Riverpod so auth redirects (Stage 2)
/// can be driven by session state without rebuilding the app shell.
class SeasonPalApp extends ConsumerWidget {
  const SeasonPalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      title: 'SeasonPal',
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
    );
  }
}
