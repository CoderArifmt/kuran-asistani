import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../l10n/app_localizations.dart';
import 'stitch_quran_grid_page.dart';
import 'surah_detail_page.dart';

class MoreFavoritesPage extends ConsumerWidget {
  const MoreFavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoritesAsync = ref.watch(favoriteDuaIdsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                // Header
                Container(
                  height: 56,
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.9),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      ),
                      Expanded(
                        child: Text(
                          l10n.favorites,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF18181B),
                              ),
                        ),
                      ),
                      const SizedBox(width: 48, height: 48),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: favoritesAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('${l10n.error}: $e'),
                      ),
                    ),
                    data: (duaIds) {
                      final duaItems = allDuaItems
                          .where((d) => duaIds.contains(d.id))
                          .toList();

                      final surahsAsync = ref.watch(surahListProvider);
                      final favSurahsAsync = ref.watch(
                        favoriteSurahNumbersProvider,
                      );

                      if (duaItems.isEmpty &&
                          (favSurahsAsync.value == null ||
                              favSurahsAsync.value!.isEmpty)) {
                        return ListView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                          children: [
                            Text(
                              l10n.quranAndDuasTitle,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.quranAndDuas,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    height: 1.4,
                                    color: isDark
                                        ? const Color(0xFFD1D5DB)
                                        : const Color(0xFF4B5563),
                                  ),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 72,
                                    color: isDark
                                        ? const Color(0xFF6B7280)
                                        : const Color(0xFF9CA3AF),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    l10n.noResultsFound,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        children: [
                          if (favSurahsAsync.value != null &&
                              favSurahsAsync.value!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8.0,
                                top: 4,
                              ),
                              child: Text(
                                l10n.favorites,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (favSurahsAsync.value != null &&
                              favSurahsAsync.value!.isNotEmpty)
                            surahsAsync.when(
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (e, _) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text('${l10n.errorLoadingSurahs} $e'),
                              ),
                              data: (surahs) {
                                final favNumbers =
                                    favSurahsAsync.value ?? <int>{};
                                final favSurahs = surahs
                                    .where((s) => favNumbers.contains(s.number))
                                    .toList();
                                return Column(
                                  children: favSurahs.map((s) {
                                    final trName = s.englishName;
                                    return ListTile(
                                      leading: const Icon(Icons.menu_book),
                                      title: Text(trName),
                                      subtitle: Text(
                                        '${s.name} • ${s.englishName}',
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => SurahDetailPage(
                                              surahNumber: s.number,
                                              surahNameTr: trName,
                                              surahNameAr: s.name,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          if (duaItems.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8.0,
                                top: 16,
                              ),
                              child: Text(
                                l10n.duas,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            ...duaItems.map((dua) {
                              final isDark =
                                  Theme.of(context).brightness ==
                                  Brightness.dark;
                              final bg = isDark ? dua.bgDark : dua.bgLight;
                              final textMain = isDark
                                  ? dua.bgLight
                                  : dua.bgDark;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.self_improvement,
                                        color: textMain,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            // Use localized title if available
                                            localizedDuaTexts(
                                              context,
                                              dua,
                                            )['title']!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: textMain,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            localizedDuaTexts(
                                              context,
                                              dua,
                                            )['subtitle']!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: textMain.withValues(
                                                alpha: 0.8,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Localize dua titles/subtitles similar to StitchQuranDuaPageGrid
Map<String, String> localizedDuaTexts(BuildContext context, DuaItem dua) {
  final lang = Localizations.localeOf(context).languageCode;
  if (lang != 'en') {
    return {'title': dua.title, 'subtitle': dua.subtitle};
  }
  switch (dua.id) {
    case 'subhaneke':
      return {
        'title': 'Subhanaka Dua',
        'subtitle': 'Recited at the beginning of the prayer',
      };
    case 'tahiyyat':
      return {
        'title': 'Tashahhud (Attahiyyatu) Dua',
        'subtitle': 'Recited while sitting in the prayer',
      };
    case 'salli_barik':
      return {
        'title': 'Allahumma Salli (Salawat)',
        'subtitle': 'Recited in the final sitting of the prayer',
      };
    case 'barik':
      return {
        'title': 'Allahumma Barik (Salawat)',
        'subtitle': 'Recited in the final sitting of the prayer',
      };
    case 'rabbena':
      return {
        'title': 'Rabbana Supplications',
        'subtitle': 'Recited for all kinds of needs and duas',
      };
    case 'ayetelkursi':
      return {
        'title': 'Ayat al-Kursi',
        'subtitle': 'Verse of protection and blessing (Al-Baqarah 255)',
      };
    case 'rabbi_yessir':
      return {
        'title': 'Rabbi Yassir Dua',
        'subtitle': 'Recited for ease before starting tasks',
      };
    case 'seyyidul_istigfar':
      return {
        'title': 'Sayyid al-Istighfar',
        'subtitle': 'One of the most virtuous duas for seeking forgiveness',
      };
    case 'hasbunallah':
      return {
        'title': 'Hasbunallahu wa Ni`mal Wakil',
        'subtitle': 'Recited in times of difficulty and reliance upon Allah',
      };
    case 'kunut1':
      return {'title': 'Qunoot Dua 1', 'subtitle': 'Recited in Witr prayer'};
    case 'kunut2':
      return {'title': 'Qunoot Dua 2', 'subtitle': 'Recited in Witr prayer'};
    case 'yemek':
      return {
        'title': 'Dua After Eating',
        'subtitle': 'Recited after finishing a meal',
      };
    default:
      return {'title': dua.title, 'subtitle': dua.subtitle};
  }
}
