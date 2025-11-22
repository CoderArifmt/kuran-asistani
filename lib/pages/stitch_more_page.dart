import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'settings_page.dart';
import 'about_page.dart';
import 'more_prayer_calendar_page.dart';
import 'more_reminders_page.dart';
import 'more_islamic_calendar_page.dart';
import 'more_nearby_mosques_page.dart';
import 'more_favorites_page.dart';
import 'more_support_donations_page.dart';
import 'more_account_data_page.dart';
import 'tesbih_counter_page.dart';
import 'names_of_allah_page.dart';
import 'prayer_tracker_page.dart';
import 'hadith_page.dart';
import 'prayer_guide_page.dart';
import 'prayer_journal_page.dart';
import 'ramadan_page.dart';
import 'hajj_umrah_guide_page.dart';

class StitchMorePage extends StatelessWidget {
  const StitchMorePage({super.key, this.onNavigateToTab});

  /// Optional callback to switch the main bottom navigation tab.
  final void Function(int index)? onNavigateToTab;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = _getMoreItems(context);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 56,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                color: cs.surface.withValues(alpha: 0.8),
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.transparent,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 48, height: 48),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).more,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48, height: 48),
                ],
              ),
            ),
            // Grid content with RepaintBoundary for performance
            Expanded(
              child: RepaintBoundary(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.8,
                            ),
                        itemCount: items.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _MoreItem(
                            icon: item.icon,
                            label: item.label,
                            onTap: item.onTap,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_MoreItemData> _getMoreItems(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      _MoreItemData(
        icon: Icons.settings,
        label: l10n.settings,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const SettingsPage())),
      ),
      _MoreItemData(
        icon: Icons.auto_awesome,
        label: l10n.tesbih,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const TesbihCounterPage())),
      ),
      _MoreItemData(
        icon: Icons.calendar_month,
        label: l10n.prayerCalendar,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MorePrayerCalendarPage()),
        ),
      ),
      _MoreItemData(
        icon: Icons.menu_book,
        label: l10n.quranAndDuas,
        onTap: () => onNavigateToTab?.call(2),
      ),
      _MoreItemData(
        icon: Icons.stars,
        label: l10n.namesOfAllah,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const NamesOfAllahPage())),
      ),
      _MoreItemData(
        icon: Icons.check_circle,
        label: l10n.prayerTracker,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const PrayerTrackerPage())),
      ),
      _MoreItemData(
        icon: Icons.notifications_active,
        label: l10n.reminders,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MoreRemindersPage())),
      ),
      _MoreItemData(
        icon: Icons.explore,
        label: l10n.qibla,
        onTap: () => onNavigateToTab?.call(1),
      ),
      _MoreItemData(
        icon: Icons.auto_stories,
        label: l10n.hadith,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const HadithPage())),
      ),
      _MoreItemData(
        icon: Icons.menu_book,
        label: l10n.prayerGuide,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const PrayerGuidePage())),
      ),
      _MoreItemData(
        icon: Icons.edit_note,
        label: l10n.prayerJournal,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const PrayerJournalPage())),
      ),
      _MoreItemData(
        icon: Icons.nightlight_round,
        label: l10n.ramadan,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const RamadanPage())),
      ),
      _MoreItemData(
        icon: Icons.mosque,
        label: l10n.hajjUmrah,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const HajjUmrahGuidePage())),
      ),
      _MoreItemData(
        icon: Icons.calendar_today,
        label: l10n.islamicCalendar,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MoreIslamicCalendarPage()),
        ),
      ),
      _MoreItemData(
        icon: Icons.location_on,
        label: l10n.nearbyMosques,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MoreNearbyMosquesPage()),
        ),
      ),
      _MoreItemData(
        icon: Icons.favorite,
        label: l10n.favorites,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MoreFavoritesPage())),
      ),
      _MoreItemData(
        icon: Icons.volunteer_activism,
        label: l10n.support,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MoreSupportDonationsPage()),
        ),
      ),
      _MoreItemData(
        icon: Icons.account_circle,
        label: l10n.accountData,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MoreAccountDataPage())),
      ),
      _MoreItemData(
        icon: Icons.info,
        label: l10n.about,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AboutPage())),
      ),
    ];
  }
}

// Data class for more items
class _MoreItemData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _MoreItemData({required this.icon, required this.label, required this.onTap});
}

// Optimized widget with RepaintBoundary
class _MoreItem extends StatelessWidget {
  const _MoreItem({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1C2C24) : Colors.white;
    final iconBg = const Color(
      0xFF14B866,
    ).withValues(alpha: isDark ? 0.2 : 0.1);
    const iconColor = Color(0xFF14B866);
    final textColor = isDark
        ? const Color(0xFFE5E7EB)
        : const Color(0xFF27272A);

    return RepaintBoundary(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
