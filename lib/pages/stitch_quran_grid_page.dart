import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../l10n/app_localizations.dart';
import '../providers/app_providers.dart';
import 'surah_detail_page.dart';
import 'dua_detail_page.dart';

// Surenin Türkçe isimleri (numaraya göre)
const Map<int, String> _surahTurkishNames = {
  1: 'Fâtiha',
  2: 'Bakara',
  3: 'Âl-i İmrân',
  4: 'Nisâ',
  5: 'Mâide',
  6: 'En\'âm',
  7: 'A\'râf',
  8: 'Enfâl',
  9: 'Tevbe',
  10: 'Yûnus',
  11: 'Hûd',
  12: 'Yûsuf',
  13: 'Ra\'d',
  14: 'İbrâhîm',
  15: 'Hicr',
  16: 'Nahl',
  17: 'İsrâ',
  18: 'Kehf',
  19: 'Meryem',
  20: 'Tâhâ',
  21: 'Enbiyâ',
  22: 'Hacc',
  23: 'Mü\'minûn',
  24: 'Nûr',
  25: 'Furkân',
  26: 'Şuarâ',
  27: 'Neml',
  28: 'Kasas',
  29: 'Ankebût',
  30: 'Rûm',
  31: 'Lokmân',
  32: 'Secde',
  33: 'Ahzâb',
  34: 'Sebe\'',
  35: 'Fâtır',
  36: 'Yâsîn',
  37: 'Sâffât',
  38: 'Sâd',
  39: 'Zümer',
  40: 'Mü\'min (Ğâfir)',
  41: 'Fussilet',
  42: 'Şûrâ',
  43: 'Zuhruf',
  44: 'Duhân',
  45: 'Câsiye',
  46: 'Ahkâf',
  47: 'Muhammed',
  48: 'Fetih',
  49: 'Hucurât',
  50: 'Kaf',
  51: 'Zâriyât',
  52: 'Tûr',
  53: 'Necm',
  54: 'Kamer',
  55: 'Rahmân',
  56: 'Vâkıa',
  57: 'Hadîd',
  58: 'Mücâdele',
  59: 'Haşr',
  60: 'Mümtehine',
  61: 'Saff',
  62: 'Cum\'a',
  63: 'Münâfikûn',
  64: 'Tegâbün',
  65: 'Talâk',
  66: 'Tahrîm',
  67: 'Mülk',
  68: 'Kalem',
  69: 'Hâkka',
  70: 'Meâric',
  71: 'Nûh',
  72: 'Cin',
  73: 'Müzzemmil',
  74: 'Müddessir',
  75: 'Kıyâme',
  76: 'İnsan',
  77: 'Mürselât',
  78: 'Nebe\'',
  79: 'Nâziât',
  80: 'Abese',
  81: 'Tekvîr',
  82: 'İnfitâr',
  83: 'Mutaffifîn',
  84: 'İnşikak',
  85: 'Bürûc',
  86: 'Târık',
  87: 'A\'lâ',
  88: 'Gâşiye',
  89: 'Fecr',
  90: 'Beled',
  91: 'Şems',
  92: 'Leyl',
  93: 'Duha',
  94: 'İnşirâh (Şerh)',
  95: 'Tîn',
  96: 'Alak',
  97: 'Kadr',
  98: 'Beyyine',
  99: 'Zilzâl',
  100: 'Âdiyât',
  101: 'Kâria',
  102: 'Tekâsür',
  103: 'Asr',
  104: 'Hümeze',
  105: 'Fîl',
  106: 'Kureyş',
  107: 'Mâûn',
  108: 'Kevser',
  109: 'Kâfirûn',
  110: 'Nasr',
  111: 'Tebbet (Mesed)',
  112: 'İhlâs',
  113: 'Felâk',
  114: 'Nâs',
};

class DuaItem {
  final String id;
  final String title;
  final String subtitle;
  final String audioUrl;
  final Color bgLight;
  final Color bgDark;

  const DuaItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.audioUrl,
    required this.bgLight,
    required this.bgDark,
  });
}

/// Temel dua kartları için kullanılan listeyi dışarı da aç.
const List<DuaItem> allDuaItems = _duaItems;

// Temel dualar listesi
const List<DuaItem> _duaItems = [
  DuaItem(
    id: 'subhaneke',
    title: 'Sübhaneke Duası',
    subtitle: 'Namazın başlangıcında okunur',
    audioUrl: 'https://www.islamcan.com/audio/duas/subhaneke.mp3',
    bgLight: Color(0xFFCFE8FA),
    bgDark: Color(0xFF2A5470),
  ),
  DuaItem(
    id: 'tahiyyat',
    title: 'Tahiyyat (Ettahiyyâtü)',
    subtitle: 'Namazların oturuşlarında okunur',
    audioUrl: 'https://www.islamcan.com/audio/duas/tahiyyat.mp3',
    bgLight: Color(0xFFD6F7D0),
    bgDark: Color(0xFF36702A),
  ),
  DuaItem(
    id: 'salli_barik',
    title: 'Salli Barik Duaları',
    subtitle: 'Namazların son oturuşunda okunur',
    audioUrl: 'https://www.islamcan.com/audio/duas/allahumma-salli.mp3',
    bgLight: Color(0xFFFFF6D9),
    bgDark: Color(0xFF70612A),
  ),
  DuaItem(
    id: 'barik',
    title: 'Barik Duası',
    subtitle: 'Namazların son oturuşunda okunur',
    audioUrl: 'https://www.islamcan.com/audio/duas/allahumma-barik.mp3',
    bgLight: Color(0xFFFFFDE7),
    bgDark: Color(0xFF795548),
  ),
  DuaItem(
    id: 'rabbena',
    title: 'Rabbena Duaları',
    subtitle: 'Her türlü dilek için okunur',
    audioUrl: 'https://www.islamcan.com/audio/duas/rabbana-atina.mp3',
    bgLight: Color(0xFFFCE0E8),
    bgDark: Color(0xFF702A43),
  ),
  DuaItem(
    id: 'ayetelkursi',
    title: 'Âyetel Kürsî',
    subtitle: 'Korunma ve bereket için okunur',
    audioUrl: 'https://GERCEK-URL/ayetel_kursi.mp3',
    bgLight: Color(0xFFE0F2FE),
    bgDark: Color(0xFF1D4ED8),
  ),
  DuaItem(
    id: 'rabbi_yessir',
    title: 'Rabbi Yessir Duası',
    subtitle: 'İşlere başlarken kolaylık için',
    audioUrl: 'https://GERCEK-URL/rabbi_yessir.mp3',
    bgLight: Color(0xFFE0F7FA),
    bgDark: Color(0xFF006064),
  ),
  DuaItem(
    id: 'seyyidul_istigfar',
    title: 'Seyyidü\'l İstiğfar',
    subtitle: 'En faziletli istiğfar duası',
    audioUrl: 'https://GERCEK-URL/seyyidul_istigfar.mp3',
    bgLight: Color(0xFFF1F5F9),
    bgDark: Color(0xFF0F172A),
  ),
  DuaItem(
    id: 'hasbunallah',
    title: 'Hasbünâllâhu',
    subtitle: 'Sıkıntılı anlarda tevekkül için',
    audioUrl: 'https://GERCEK-URL/hasbunallah.mp3',
    bgLight: Color(0xFFFEE2E2),
    bgDark: Color(0xFFB91C1C),
  ),
  DuaItem(
    id: 'kunut1',
    title: 'Kunut Duası 1',
    subtitle: 'Vitir namazı duası',
    audioUrl: 'https://www.islamcan.com/audio/duas/qunoot-1.mp3',
    bgLight: Color(0xFFE0F7FA),
    bgDark: Color(0xFF006064),
  ),
  DuaItem(
    id: 'kunut2',
    title: 'Kunut Duası 2',
    subtitle: 'Vitir namazı duası',
    audioUrl: 'https://www.islamcan.com/audio/duas/qunoot-2.mp3',
    bgLight: Color(0xFFE5E7EB),
    bgDark: Color(0xFF374151),
  ),
  DuaItem(
    id: 'yemek',
    title: 'Yemek Duası',
    subtitle: 'Yemekten sonra okunur',
    audioUrl: 'https://www.islamcan.com/audio/duas/meal-prayer.mp3',
    bgLight: Color(0xFFE0F2FE),
    bgDark: Color(0xFF1D4ED8),
  ),
];

class StitchQuranDuaPageGrid extends ConsumerStatefulWidget {
  const StitchQuranDuaPageGrid({super.key});

  @override
  ConsumerState<StitchQuranDuaPageGrid> createState() =>
      _StitchQuranDuaPageGridState();
}

class _StitchQuranDuaPageGridState
    extends ConsumerState<StitchQuranDuaPageGrid> {
  String _searchQuery = '';
  int _selectedTab = 0; // 0: Sureler, 1: Dualar, 2: Favoriler

  final AudioPlayer _duaPlayer = AudioPlayer();
  String? _currentDuaId;
  bool _isDuaLoading = false;

  @override
  void dispose() {
    _duaPlayer.dispose();
    super.dispose();
  }

  Future<void> _onDuaPressed(DuaItem dua) async {
    if (_currentDuaId == dua.id && _duaPlayer.playing) {
      try {
        await _duaPlayer.stop();
      } catch (e) {
        debugPrint('Dua stop error: $e');
      }
      if (mounted) setState(() {});
      return;
    }
    setState(() {
      _currentDuaId = dua.id;
      _isDuaLoading = true;
    });
    try {
      await _duaPlayer.stop();
      await _duaPlayer.setUrl(dua.audioUrl);
      await _duaPlayer.play();
    } catch (e) {
      debugPrint('Dua play error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isDuaLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final asyncSurahs = ref.watch(surahListProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar.large(
              title: Text(l10n.quranAndDuasTitle),
              centerTitle: false,
              scrolledUnderElevation: 0,
              backgroundColor: theme.scaffoldBackgroundColor,
              surfaceTintColor: Colors.transparent,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SearchBar(
                      hintText: _selectedTab == 0
                          ? l10n.searchSurah
                          : (_selectedTab == 1
                                ? l10n.searchDua
                                : l10n.searchFavorite),
                      elevation: WidgetStateProperty.all(0),
                      backgroundColor: WidgetStateProperty.all(
                        theme.cardTheme.color ?? cs.surface,
                      ),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      leading: Icon(Icons.search, color: cs.onSurfaceVariant),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.trim();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<int>(
                        segments: [
                          ButtonSegment(
                            value: 0,
                            label: FittedBox(child: Text(l10n.surahs)),
                            icon: const Icon(Icons.menu_book_outlined),
                          ),
                          ButtonSegment(
                            value: 1,
                            label: FittedBox(child: Text(l10n.duas)),
                            icon: const Icon(Icons.volunteer_activism_outlined),
                          ),
                          ButtonSegment(
                            value: 2,
                            label: FittedBox(child: Text(l10n.favorites)),
                            icon: const Icon(Icons.favorite),
                          ),
                        ],
                        selected: {_selectedTab},
                        onSelectionChanged: (Set<int> newSelection) {
                          setState(() {
                            _selectedTab = newSelection.first;
                          });
                        },
                        style: ButtonStyle(
                          visualDensity: VisualDensity.comfortable,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: WidgetStateProperty.all(BorderSide.none),
                          backgroundColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return cs.primaryContainer;
                            }
                            return theme.cardTheme.color ?? cs.surface;
                          }),
                          foregroundColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return cs.onPrimaryContainer;
                            }
                            return cs.onSurfaceVariant;
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ];
        },
        body: asyncSurahs.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('${l10n.errorLoadingSurahs} $e')),
          data: (surahs) {
            final query = _searchQuery.toLowerCase();
            final filteredSurahs = query.isEmpty
                ? surahs
                : surahs.where((s) {
                    final tr = (_surahTurkishNames[s.number] ?? '')
                        .toLowerCase();
                    return s.name.toLowerCase().contains(query) ||
                        s.englishName.toLowerCase().contains(query) ||
                        tr.contains(query) ||
                        s.number.toString() == query;
                  }).toList();

            final localizedDuas = _duaItems
                .map((d) => _getLocalizedDua(context, d))
                .toList();
            final filteredDuas = query.isEmpty
                ? localizedDuas
                : localizedDuas
                      .where((d) => d.title.toLowerCase().contains(query))
                      .toList();

            if (_selectedTab == 0) {
              if (filteredSurahs.isEmpty) {
                return Center(child: Text(l10n.noResultsFound));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                itemCount: filteredSurahs.length,
                itemBuilder: (context, index) {
                  final s = filteredSurahs[index];
                  final displayName = _getSurahName(context, s);
                  final favAsync = ref.watch(favoriteSurahNumbersProvider);
                  final isFavorite =
                      favAsync.value?.contains(s.number) ?? false;
                  return _M3SurahCard(
                    number: s.number,
                    arabicName: s.name,
                    turkishName: displayName,
                    englishName: s.englishName,
                    ayahCount: s.ayahCount,
                    revelationType: s.revelationType,
                    isFavorite: isFavorite,
                    onToggleFavorite: () async {
                      final service = ref.read(favoritesServiceProvider);
                      await service.toggleFavoriteSurah(s.number);
                      ref.invalidate(favoriteSurahNumbersProvider);
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SurahDetailPage(
                            surahNumber: s.number,
                            surahNameTr: displayName,
                            surahNameAr: s.name,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (_selectedTab == 1) {
              if (filteredDuas.isEmpty) {
                return Center(child: Text(l10n.noResultsFound));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                itemCount: filteredDuas.length,
                itemBuilder: (context, index) {
                  final dua = filteredDuas[index];
                  final isCurrent = _currentDuaId == dua.id;
                  final isPlaying = isCurrent && _duaPlayer.playing;
                  final isLoading = isCurrent && _isDuaLoading;
                  final favAsync = ref.watch(favoriteDuaIdsProvider);
                  final isFavorite = favAsync.value?.contains(dua.id) ?? false;
                  return _M3DuaCard(
                    item: dua,
                    isCurrent: isCurrent,
                    isPlaying: isPlaying,
                    isLoading: isLoading,
                    isFavorite: isFavorite,
                    onToggleFavorite: () async {
                      final service = ref.read(favoritesServiceProvider);
                      await service.toggleFavoriteDua(dua.id);
                      ref.invalidate(favoriteDuaIdsProvider);
                    },
                    onPlayPause: () => _onDuaPressed(dua),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DuaDetailPage(
                            duaId: dua.id,
                            title: dua.title,
                            subtitle: dua.subtitle,
                            audioUrl: dua.audioUrl,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              // Favorites tab
              final favSurahNumbers =
                  ref.watch(favoriteSurahNumbersProvider).value ?? <int>{};
              final favDuaIds =
                  ref.watch(favoriteDuaIdsProvider).value ?? <String>{};
              final surahAsync = ref.watch(surahListProvider);
              return surahAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text('${l10n.errorLoadingSurahs} $e')),
                data: (surahs) {
                  final favSurahs = surahs
                      .where((s) => favSurahNumbers.contains(s.number))
                      .toList();
                  final favDuas = localizedDuas
                      .where((d) => favDuaIds.contains(d.id))
                      .toList();

                  if (favSurahs.isEmpty && favDuas.isEmpty) {
                    return Center(child: Text(l10n.noFavoritesFound));
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      if (favSurahs.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 4),
                          child: Text(
                            l10n.favoriteSurahs,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        ...favSurahs.map((s) {
                          final displayName = _getSurahName(context, s);
                          return ListTile(
                            leading: const Icon(Icons.menu_book),
                            title: Text(displayName),
                            subtitle: Text('${s.name} • ${s.englishName}'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SurahDetailPage(
                                    surahNumber: s.number,
                                    surahNameTr: displayName,
                                    surahNameAr: s.name,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                      if (favDuas.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 16),
                          child: Text(
                            l10n.favoriteDuas,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        ...favDuas.map((dua) {
                          final isDark =
                              Theme.of(context).brightness == Brightness.dark;
                          final bg = isDark ? dua.bgDark : dua.bgLight;
                          final textMain = isDark ? dua.bgLight : dua.bgDark;
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
                                    color: Colors.white.withValues(alpha: 0.5),
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
                                        dua.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: textMain,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        dua.subtitle,
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
              );
            }
          },
        ),
      ),
    );
  }

  String _getSurahName(BuildContext context, dynamic s) {
    final l10n = AppLocalizations.of(context);
    if (l10n.locale.languageCode == 'tr') {
      return _surahTurkishNames[s.number] ?? s.englishName;
    }
    return s.englishName;
  }

  DuaItem _getLocalizedDua(BuildContext context, DuaItem item) {
    final l10n = AppLocalizations.of(context);
    String title = item.title;
    String subtitle = item.subtitle;

    switch (item.id) {
      case 'subhaneke':
        title = l10n.subhanekeTitle;
        subtitle = l10n.subhanekeSubtitle;
        break;
      case 'tahiyyat':
        title = l10n.tahiyyatTitle;
        subtitle = l10n.tahiyyatSubtitle;
        break;
      case 'salli_barik':
        title = l10n.salliBarikTitle;
        subtitle = l10n.salliBarikSubtitle;
        break;
      case 'barik':
        title = l10n.barikTitle;
        subtitle = l10n.barikSubtitle;
        break;
      case 'rabbena':
        title = l10n.rabbenaTitle;
        subtitle = l10n.rabbenaSubtitle;
        break;
      case 'ayetelkursi':
        title = l10n.ayetelkursiTitle;
        subtitle = l10n.ayetelkursiSubtitle;
        break;
      case 'rabbi_yessir':
        title = l10n.rabbiYessirTitle;
        subtitle = l10n.rabbiYessirSubtitle;
        break;
      case 'seyyidul_istigfar':
        title = l10n.seyyidulIstigfarTitle;
        subtitle = l10n.seyyidulIstigfarSubtitle;
        break;
      case 'hasbunallah':
        title = l10n.hasbunallahTitle;
        subtitle = l10n.hasbunallahSubtitle;
        break;
      case 'kunut1':
        title = l10n.kunut1Title;
        subtitle = l10n.kunut1Subtitle;
        break;
      case 'kunut2':
        title = l10n.kunut2Title;
        subtitle = l10n.kunut2Subtitle;
        break;
      case 'yemek':
        title = l10n.yemekTitle;
        subtitle = l10n.yemekSubtitle;
        break;
    }

    return DuaItem(
      id: item.id,
      title: title,
      subtitle: subtitle,
      audioUrl: item.audioUrl,
      bgLight: item.bgLight,
      bgDark: item.bgDark,
    );
  }
}

class _M3SurahCard extends StatelessWidget {
  final int number;
  final String arabicName;
  final String turkishName;
  final String englishName;
  final int ayahCount;
  final String revelationType;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const _M3SurahCard({
    required this.number,
    required this.arabicName,
    required this.turkishName,
    required this.englishName,
    required this.ayahCount,
    required this.revelationType,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final revTr = revelationType.toLowerCase() == 'meccan'
        ? l10n.mecca
        : l10n.medina;

    return Card(
      elevation: 0,
      color: theme.cardTheme.color,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Number Badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          turkishName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          arabicName,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$englishName • $revTr • $ayahCount ${l10n.verses}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite
                      ? const Color(0xFFF59E0B)
                      : cs.onSurfaceVariant,
                ),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _M3DuaCard extends StatelessWidget {
  final DuaItem item;
  final bool isCurrent;
  final bool isPlaying;
  final bool isLoading;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onPlayPause;
  final VoidCallback onTap;

  const _M3DuaCard({
    required this.item,
    required this.isCurrent,
    required this.isPlaying,
    required this.isLoading,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onPlayPause,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      elevation: 0,
      color: theme.cardTheme.color,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.volunteer_activism, color: cs.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite
                      ? const Color(0xFFF59E0B)
                      : cs.onSurfaceVariant,
                ),
                onPressed: onToggleFavorite,
              ),
              IconButton.filledTonal(
                onPressed: onPlayPause,
                style: IconButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                ),
                icon: isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: cs.onPrimary,
                        ),
                      )
                    : Icon(
                        isCurrent && isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
