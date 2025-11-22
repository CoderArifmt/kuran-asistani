import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'stitch_home_page.dart';
import 'stitch_qibla_page.dart';
import 'stitch_quran_grid_page.dart';
import 'stitch_more_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // Sayfaları burada oluştur ki "Daha Fazla" sekmesine bir callback verebilelim.
    final pages = [
      const StitchHomePage(),
      const StitchQiblaPage(),
      const StitchQuranDuaPageGrid(),
      StitchMorePage(
        onNavigateToTab: (idx) => setState(() => _index = idx),
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: _buildBottomNav(context),
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
          onTap: () => setState(() => _index = idx),
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