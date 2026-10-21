import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Hosts the five product sections and keeps each tab's navigator alive while
/// the cook moves around the app.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.creamRaised,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          destinations: [
            NavigationDestination(
              key: const Key('nav-home'),
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: t.navigation.home,
            ),
            NavigationDestination(
              key: const Key('nav-discover'),
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: const Icon(Icons.explore_rounded),
              label: t.navigation.discover,
            ),
            NavigationDestination(
              key: const Key('nav-ai'),
              icon: const Icon(Icons.auto_awesome_outlined),
              selectedIcon: const Icon(Icons.auto_awesome_rounded),
              label: t.navigation.aiCook,
            ),
            NavigationDestination(
              key: const Key('nav-library'),
              icon: const Icon(Icons.menu_book_outlined),
              selectedIcon: const Icon(Icons.menu_book_rounded),
              label: t.navigation.myRecipes,
            ),
            NavigationDestination(
              key: const Key('nav-profile'),
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: t.navigation.profile,
            ),
          ],
        ),
      ),
    );
  }
}
