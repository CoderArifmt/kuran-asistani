import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import 'stitch_home_page.dart';
import 'stitch_qibla_page.dart';
import 'stitch_quran_grid_page.dart';
import 'stitch_more_page.dart';

// Global key to access StitchHomePageState from other parts of the app
final GlobalKey<StitchHomePageState> stitchHomePageKey =
    GlobalKey<StitchHomePageState>();

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    // Sayfaları burada oluştur ki "Daha Fazla" sekmesine bir callback verebilelim.
    final pages = [
      StitchHomePage(key: stitchHomePageKey), // Pass the global key here
      const StitchQiblaPage(),
      const StitchQuranDuaPageGrid(),
      StitchMorePage(onNavigateToTab: (idx) => setState(() => _index = idx)),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final navigator = _navigatorKeys[_index].currentState;
        if (navigator != null && await navigator.maybePop()) {
          return;
        }

        if (_index != 0) {
          setState(() => _index = 0);
          return;
        }

        // Exit the app
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: pages
              .asMap()
              .entries
              .map((e) => _buildNavigator(e.key, e.value))
              .toList(),
        ),
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildNavigator(int index, Widget child) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget item(IconData icon, String label, int idx) {
      final selected = _index == idx;
      final color = selected
          ? const Color(0xFF14B866)
          : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280));
      final fontWeight = selected ? FontWeight.w600 : FontWeight.w500;
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () {
            if (_index == idx) {
              // If tapping the same tab, pop to root
              _navigatorKeys[idx].currentState?.popUntil(
                (route) => route.isFirst,
              );
            } else {
              setState(() => _index = idx);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 24, color: color),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: fontWeight,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            item(Icons.home, AppLocalizations.of(context).home, 0),
            item(Icons.explore, AppLocalizations.of(context).qibla, 1),
            item(Icons.menu_book, AppLocalizations.of(context).quran, 2),
            item(Icons.more_horiz, AppLocalizations.of(context).more, 3),
          ],
        ),
      ),
    );
  }
}
