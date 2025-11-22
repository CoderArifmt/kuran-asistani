import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import 'dart:math';

class HadithPage extends StatefulWidget {
  const HadithPage({super.key});

  @override
  State<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  int _currentIndex = 0;
  Set<int> _favorites = {};

  @override
  void initState() {
    super.initState();
    _loadDailyHadith();
    _loadFavorites();
  }

  Future<void> _loadDailyHadith() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('hadith_date');
    final today = DateTime.now().toString().substring(0, 10);

    if (savedDate != today) {
      // Yeni gün, random hadis seç
      _currentIndex = Random().nextInt(_hadiths.length);
      await prefs.setString('hadith_date', today);
      await prefs.setInt('hadith_index', _currentIndex);
    } else {
      _currentIndex = prefs.getInt('hadith_index') ?? 0;
    }
    setState(() {});
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('hadith_favorites') ?? [];
    setState(() {
      _favorites = favList.map((e) => int.parse(e)).toSet();
    });
  }

  Future<void> _toggleFavorite(int index) async {
    setState(() {
      if (_favorites.contains(index)) {
        _favorites.remove(index);
      } else {
        _favorites.add(index);
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'hadith_favorites',
      _favorites.map((e) => e.toString()).toList(),
    );
  }

  void _showRandomHadith() {
    setState(() {
      _currentIndex = Random().nextInt(_hadiths.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localized = localizedHadith(context, _currentIndex);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 56,
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).hadith,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showRandomHadith,
                    icon: const Icon(Icons.shuffle, size: 24),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Hadith Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1F2937) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.2 : 0.05,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF14B866,
                              ).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.menu_book,
                              size: 48,
                              color: Color(0xFF14B866),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Hadith Text
                          Text(
                            localized['text']!,
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.8,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF111827),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Source
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF14B866,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              localized['source']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF14B866),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _toggleFavorite(_currentIndex),
                          icon: Icon(
                            _favorites.contains(_currentIndex)
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          label: Text(
                            _favorites.contains(_currentIndex)
                                ? AppLocalizations.of(
                                    context,
                                  ).removeFromFavorites
                                : AppLocalizations.of(context).addToFavorites,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _favorites.contains(_currentIndex)
                                ? const Color(0xFF14B866)
                                : (isDark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade200),
                            foregroundColor: _favorites.contains(_currentIndex)
                                ? Colors.white
                                : (isDark
                                      ? Colors.white
                                      : Colors.grey.shade800),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Hadis-i Şerif koleksiyonu
final List<Map<String, String>> _hadiths = [
  {
    'text':
        'Müslüman, Müslümanların elinden ve dilinden emin oldukları kimsedir.',
    'source': 'Buhari',
  },
  {
    'text': 'İnsanların en hayırlısı, insanlara faydalı olandır.',
    'source': 'Taberani',
  },
  {'text': 'Güzel ahlak, cennet evlerinin en güzelidir.', 'source': 'Tirmizi'},
  {
    'text': 'Allah\'a itaat edene bütün mahlûkat itaat eder.',
    'source': 'Ebu Nuaym',
  },
  {'text': 'İman ile kibir bir arada bulunmaz.', 'source': 'Taberani'},
  {
    'text':
        'İyilik yapan ile iyiliği yayıp başkalarına öğreten, sevap bakımından birdir.',
    'source': 'Tirmizi',
  },
  {
    'text':
        'Size nezaket ve yumuşak huylulukla tavsiyede bulunurum. Her şeyde nezaket güzellik ve ziynetlik verir.',
    'source': 'Müslim',
  },
  {'text': 'Cennet, anaların ayakları altındadır.', 'source': 'Nesai'},
  {
    'text':
        'Tevazu ediniz. Çünkü tevazu, bir şeyi zayıf ve hakir kılmaz. Ancak onu yüceltir ve büyütür.',
    'source': 'Müslim',
  },
  {
    'text':
        'İman, yetmiş küsür şubedir. En yükseği Allah birdir demek, en düşüğü ise yoldan taş ve eziyet verici şeyleri kaldırmaktır.',
    'source': 'Müslim',
  },
  {
    'text':
        'Kim beni dinler, takva sahibi olur. Kim de takva sahibi olursa cennete girer.',
    'source': 'Tirmizi',
  },
  {
    'text':
        'Kişinin güzel Müslümanlığından biri de kendisini ilgilendirmeyen şeyleri terk etmesidir.',
    'source': 'Tirmizi',
  },
  {
    'text':
        'Allah katında amellerin en sevimli olanı, az da olsa devam edilenidir.',
    'source': 'Buhari',
  },
  {
    'text':
        'Size iki hazinemden haber vereyim mi? Sabır belaya, şükür nimete karşıdır.',
    'source': 'Taberani',
  },
  {
    'text':
        'Allah, bir kulunu hayra yöneltmek isterse, onun kalbine nuru koyar.',
    'source': 'Hakim',
  },
  {'text': 'Güzel söz sadakadır.', 'source': 'Buhari'},
  {
    'text': 'Emaneti yerine getir, sana hıyanet edene sen hıyanet etme.',
    'source': 'Ebu Davud',
  },
  {'text': 'Allah güzeldir ve güzeli sever.', 'source': 'Müslim'},
  {'text': 'İlim Çin\'de bile olsa gidip öğreniniz.', 'source': 'Deylemî'},
  {
    'text':
        'Kötülüğü güzellikle sav. Seninle arasında düşmanlık bulunan kimse, sanki sıcak bir dost olur.',
    'source': 'Fussilet 34',
  },
];

/// Return localized hadith text/source depending on current locale.
Map<String, String> localizedHadith(BuildContext context, int index) {
  final lang = Localizations.localeOf(context).languageCode;
  final base = _hadiths[index];
  if (lang != 'en') {
    return base;
  }
  switch (index) {
    case 0:
      return {
        'text':
            'A Muslim is the one from whose tongue and hand other Muslims are safe.',
        'source': base['source'] ?? 'Bukhari',
      };
    case 1:
      return {
        'text':
            'The best of people are those who are most beneficial to people.',
        'source': base['source'] ?? 'Tabarani',
      };
    case 2:
      return {
        'text':
            'Good character is the most excellent of the houses of Paradise.',
        'source': base['source'] ?? 'Tirmidhi',
      };
    case 3:
      return {
        'text': 'All creatures are obedient to the one who obeys Allah.',
        'source': base['source'] ?? 'Abu Nuaym',
      };
    case 4:
      return {
        'text': 'Faith and arrogance do not coexist in the same heart.',
        'source': base['source'] ?? 'Tabarani',
      };
    case 5:
      return {
        'text':
            'The one who does a good deed and the one who spreads it and teaches it to others are equal in reward.',
        'source': base['source'] ?? 'Tirmidhi',
      };
    case 6:
      return {
        'text':
            'I advise you to be gentle and lenient. Gentleness adorns everything it is in.',
        'source': base['source'] ?? 'Muslim',
      };
    case 7:
      return {
        'text': 'Paradise lies under the feet of mothers.',
        'source': base['source'] ?? 'Nasa’i',
      };
    case 8:
      return {
        'text':
            'Be humble, for humility does not make a thing deficient or low; it only elevates and increases it.',
        'source': base['source'] ?? 'Muslim',
      };
    case 9:
      return {
        'text':
            'Faith has over seventy branches. The highest of them is saying: “There is no god but Allah”, and the lowest of them is removing something harmful from the road.',
        'source': base['source'] ?? 'Muslim',
      };
    case 10:
      return {
        'text':
            'Whoever hears me and has taqwa (God-consciousness) will enter Paradise.',
        'source': base['source'] ?? 'Tirmidhi',
      };
    case 11:
      return {
        'text':
            'Part of a person’s being a good Muslim is leaving that which does not concern him.',
        'source': base['source'] ?? 'Tirmidhi',
      };
    case 12:
      return {
        'text':
            'The most beloved deeds to Allah are those that are done regularly, even if they are few.',
        'source': base['source'] ?? 'Bukhari',
      };
    case 13:
      return {
        'text':
            'Shall I inform you of two treasures of mine? They are: patience in hardship and gratitude in blessing.',
        'source': base['source'] ?? 'Tabarani',
      };
    case 14:
      return {
        'text':
            'When Allah wills good for a servant, He places a light in his heart.',
        'source': base['source'] ?? 'Hakim',
      };
    case 15:
      return {
        'text': 'A good word is charity.',
        'source': base['source'] ?? 'Bukhari',
      };
    case 16:
      return {
        'text':
            'Render back the trust to the one who entrusted you, and do not betray the one who betrays you.',
        'source': base['source'] ?? 'Abu Dawud',
      };
    case 17:
      return {
        'text': 'Allah is beautiful and loves beauty.',
        'source': base['source'] ?? 'Muslim',
      };
    case 18:
      return {
        'text': 'Seek knowledge even if it is in China.',
        'source': base['source'] ?? 'Daylami',
      };
    case 19:
      return {
        'text':
            'Repel evil with that which is better; then the one between whom and you there was enmity will become as though he were a devoted friend.',
        'source': base['source'] ?? 'Qur’an, Fussilat 34',
      };
    default:
      return base;
  }
}
