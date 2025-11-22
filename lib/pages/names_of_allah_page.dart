import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class NamesOfAllahPage extends StatelessWidget {
  const NamesOfAllahPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                      '${AppLocalizations.of(context).namesOfAllah} (99)',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _namesOfAllah.length,
                itemBuilder: (context, index) {
                  final name = _namesOfAllah[index];
                  return _NameCard(
                    number: index + 1,
                    arabic: name['arabic']!,
                    transliteration: name['transliteration']!,
                    meaning: name['meaning']!,
                    isDark: isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NameCard extends StatelessWidget {
  const _NameCard({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.isDark,
  });

  final int number;
  final String arabic;
  final String transliteration;
  final String meaning;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C2C24) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Number
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF14B866).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14B866),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arabic,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF14B866),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transliteration,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _localizedNameMeaning(context, number - 1, meaning),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? const Color(0xFFD1D5DB)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Allah'ın 99 İsmi
final List<Map<String, String>> _namesOfAllah = [
  {
    'arabic': 'الرَّحْمَنُ',
    'transliteration': 'Er-Rahman',
    'meaning': 'Sonsuz merhamet sahibi',
  },
  {
    'arabic': 'الرَّحِيمُ',
    'transliteration': 'Er-Rahim',
    'meaning': 'Çok merhametli',
  },
  {
    'arabic': 'الْمَلِكُ',
    'transliteration': 'El-Melik',
    'meaning': 'Mutlak hükümdar',
  },
  {
    'arabic': 'الْقُدُّوسُ',
    'transliteration': 'El-Kuddus',
    'meaning': 'Eksiksiz temiz ve pak',
  },
  {
    'arabic': 'السَّلاَمُ',
    'transliteration': 'Es-Selam',
    'meaning': 'Kusursuz esenlik sahibi',
  },
  {
    'arabic': 'الْمُؤْمِنُ',
    'transliteration': 'El-Mumin',
    'meaning': 'Güven veren',
  },
  {
    'arabic': 'الْمُهَيْمِنُ',
    'transliteration': 'El-Muheymin',
    'meaning': 'Her şeyi gözetleyen',
  },
  {
    'arabic': 'الْعَزِيزُ',
    'transliteration': 'El-Aziz',
    'meaning': 'Üstün ve güçlü',
  },
  {
    'arabic': 'الْجَبَّارُ',
    'transliteration': 'El-Cebbar',
    'meaning': 'Mutlak güç sahibi',
  },
  {
    'arabic': 'الْمُتَكَبِّرُ',
    'transliteration': 'El-Mütekebbir',
    'meaning': 'Büyüklük sahibi',
  },
  {'arabic': 'الْخَالِقُ', 'transliteration': 'El-Halik', 'meaning': 'Yaratan'},
  {
    'arabic': 'الْبَارِئُ',
    'transliteration': 'El-Bari',
    'meaning': 'Yoktan var eden',
  },
  {
    'arabic': 'الْمُصَوِّرُ',
    'transliteration': 'El-Musavvir',
    'meaning': 'Şekil veren',
  },
  {
    'arabic': 'الْغَفَّارُ',
    'transliteration': 'El-Gaffar',
    'meaning': 'Çok bağışlayan',
  },
  {
    'arabic': 'الْقَهَّارُ',
    'transliteration': 'El-Kahhar',
    'meaning': 'Her şeye galip',
  },
  {
    'arabic': 'الْوَهَّابُ',
    'transliteration': 'El-Vehhab',
    'meaning': 'Çok bahşeden',
  },
  {
    'arabic': 'الرَّزَّاقُ',
    'transliteration': 'Er-Rezzak',
    'meaning': 'Rızık veren',
  },
  {
    'arabic': 'الْفَتَّاحُ',
    'transliteration': 'El-Fettah',
    'meaning': 'Açan, fetih veren',
  },
  {
    'arabic': 'اَلْعَلِيْمُ',
    'transliteration': 'El-Alim',
    'meaning': 'Her şeyi bilen',
  },
  {
    'arabic': 'الْقَابِضُ',
    'transliteration': 'El-Kabız',
    'meaning': 'Daraltan',
  },
  {
    'arabic': 'الْبَاسِطُ',
    'transliteration': 'El-Basıt',
    'meaning': 'Genişleten',
  },
  {
    'arabic': 'الْخَافِضُ',
    'transliteration': 'El-Hafız',
    'meaning': 'Alçaltan',
  },
  {
    'arabic': 'الرَّافِعُ',
    'transliteration': 'Er-Rafi',
    'meaning': 'Yükselten',
  },
  {
    'arabic': 'الْمُعِزُّ',
    'transliteration': 'El-Muizz',
    'meaning': 'İzzet veren',
  },
  {
    'arabic': 'المُذِلُّ',
    'transliteration': 'El-Müzill',
    'meaning': 'Zillete düşüren',
  },
  {
    'arabic': 'السَّمِيعُ',
    'transliteration': 'Es-Semi',
    'meaning': 'Her şeyi işiten',
  },
  {
    'arabic': 'الْبَصِيرُ',
    'transliteration': 'El-Basir',
    'meaning': 'Her şeyi gören',
  },
  {
    'arabic': 'الْحَكَمُ',
    'transliteration': 'El-Hakem',
    'meaning': 'Hakim olan',
  },
  {
    'arabic': 'الْعَدْلُ',
    'transliteration': 'El-Adl',
    'meaning': 'Adalet sahibi',
  },
  {
    'arabic': 'اللَّطِيفُ',
    'transliteration': 'El-Latif',
    'meaning': 'Lütuf sahibi',
  },
  {
    'arabic': 'الْخَبِيرُ',
    'transliteration': 'El-Habir',
    'meaning': 'Her şeyden haberdar',
  },
  {
    'arabic': 'الْحَلِيمُ',
    'transliteration': 'El-Halim',
    'meaning': 'Halim ve yumuşak',
  },
  {
    'arabic': 'الْعَظِيمُ',
    'transliteration': 'El-Azim',
    'meaning': 'Sonsuz büyük',
  },
  {
    'arabic': 'الْغَفُورُ',
    'transliteration': 'El-Gafur',
    'meaning': 'Çok bağışlayıcı',
  },
  {
    'arabic': 'الشَّكُورُ',
    'transliteration': 'Eş-Şekur',
    'meaning': 'Şükreden',
  },
  {
    'arabic': 'الْعَلِيُّ',
    'transliteration': 'El-Aliyy',
    'meaning': 'Yüce olan',
  },
  {
    'arabic': 'الْكَبِيرُ',
    'transliteration': 'El-Kebir',
    'meaning': 'Sonsuz büyük',
  },
  {'arabic': 'الْحَفِيظُ', 'transliteration': 'El-Hafiz', 'meaning': 'Koruyan'},
  {
    'arabic': 'المُقيِت',
    'transliteration': 'El-Mukit',
    'meaning': 'Kuvvet veren',
  },
  {
    'arabic': 'الْحسِيبُ',
    'transliteration': 'El-Hasib',
    'meaning': 'Hesap gören',
  },
  {
    'arabic': 'الْجَلِيلُ',
    'transliteration': 'El-Celil',
    'meaning': 'Celal sahibi',
  },
  {
    'arabic': 'الْكَرِيمُ',
    'transliteration': 'El-Kerim',
    'meaning': 'Cömert olan',
  },
  {
    'arabic': 'الرَّقِيبُ',
    'transliteration': 'Er-Rakib',
    'meaning': 'Gözetleyen',
  },
  {
    'arabic': 'الْمُجِيبُ',
    'transliteration': 'El-Mucib',
    'meaning': 'Duayı kabul eden',
  },
  {
    'arabic': 'الْوَاسِعُ',
    'transliteration': 'El-Vasi',
    'meaning': 'Geniş olan',
  },
  {
    'arabic': 'الْحَكِيمُ',
    'transliteration': 'El-Hakim',
    'meaning': 'Hikmet sahibi',
  },
  {
    'arabic': 'الْوَدُودُ',
    'transliteration': 'El-Vedud',
    'meaning': 'Sevgi sahibi',
  },
  {
    'arabic': 'الْمَجِيدُ',
    'transliteration': 'El-Mecid',
    'meaning': 'Şan ve şeref sahibi',
  },
  {
    'arabic': 'الْبَاعِثُ',
    'transliteration': 'El-Bais',
    'meaning': 'Yeniden dirilten',
  },
  {
    'arabic': 'الشَّهِيدُ',
    'transliteration': 'Eş-Şehid',
    'meaning': 'Şahit olan',
  },
  {'arabic': 'الْحَقُّ', 'transliteration': 'El-Hakk', 'meaning': 'Hak olan'},
  {
    'arabic': 'الْوَكِيلُ',
    'transliteration': 'El-Vekil',
    'meaning': 'Vekil olan',
  },
  {
    'arabic': 'الْقَوِيُّ',
    'transliteration': 'El-Kaviyy',
    'meaning': 'Güçlü olan',
  },
  {
    'arabic': 'الْمَتِينُ',
    'transliteration': 'El-Metin',
    'meaning': 'Sağlam olan',
  },
  {
    'arabic': 'الْوَلِيُّ',
    'transliteration': 'El-Veliyy',
    'meaning': 'Dost olan',
  },
  {
    'arabic': 'الْحَمِيدُ',
    'transliteration': 'El-Hamid',
    'meaning': 'Övülmeye layık',
  },
  {
    'arabic': 'الْمُحْصِي',
    'transliteration': 'El-Muhsi',
    'meaning': 'Sayıp hesap eden',
  },
  {
    'arabic': 'الْمُبْدِئُ',
    'transliteration': 'El-Mubdi',
    'meaning': 'Başlatan',
  },
  {
    'arabic': 'الْمُعِيدُ',
    'transliteration': 'El-Muid',
    'meaning': 'Geri döndüren',
  },
  {
    'arabic': 'الْمُحْيِي',
    'transliteration': 'El-Muhyi',
    'meaning': 'Dirilten',
  },
  {
    'arabic': 'اَلْمُمِيتُ',
    'transliteration': 'El-Mumit',
    'meaning': 'Öldüren',
  },
  {'arabic': 'الْحَيُّ', 'transliteration': 'El-Hayy', 'meaning': 'Diri olan'},
  {
    'arabic': 'الْقَيُّومُ',
    'transliteration': 'El-Kayyum',
    'meaning': 'Kendinden var olan',
  },
  {
    'arabic': 'الْوَاجِدُ',
    'transliteration': 'El-Vacid',
    'meaning': 'Zengin olan',
  },
  {
    'arabic': 'الْمَاجِدُ',
    'transliteration': 'El-Macid',
    'meaning': 'Şerefli olan',
  },
  {'arabic': 'الْواحِدُ', 'transliteration': 'El-Vahid', 'meaning': 'Bir olan'},
  {'arabic': 'اَلاَحَدُ', 'transliteration': 'El-Ehad', 'meaning': 'Tek olan'},
  {
    'arabic': 'الصَّمَدُ',
    'transliteration': 'Es-Samed',
    'meaning': 'Herkesin muhtaç olduğu',
  },
  {
    'arabic': 'الْقَادِرُ',
    'transliteration': 'El-Kadir',
    'meaning': 'Güç yetiren',
  },
  {
    'arabic': 'الْمُقْتَدِرُ',
    'transliteration': 'El-Muktedir',
    'meaning': 'Mutlak kudret sahibi',
  },
  {
    'arabic': 'الْمُقَدِّمُ',
    'transliteration': 'El-Mukaddim',
    'meaning': 'Öne alan',
  },
  {
    'arabic': 'الْمُؤَخِّرُ',
    'transliteration': 'El-Muahhir',
    'meaning': 'Geriye bırakan',
  },
  {'arabic': 'الأوَّلُ', 'transliteration': 'El-Evvel', 'meaning': 'İlk olan'},
  {'arabic': 'الآخِرُ', 'transliteration': 'El-Ahir', 'meaning': 'Son olan'},
  {
    'arabic': 'الظَّاهِرُ',
    'transliteration': 'Ez-Zahir',
    'meaning': 'Açık olan',
  },
  {
    'arabic': 'الْبَاطِنُ',
    'transliteration': 'El-Batın',
    'meaning': 'Gizli olan',
  },
  {'arabic': 'الْوَالِي', 'transliteration': 'El-Vali', 'meaning': 'Yöneten'},
  {
    'arabic': 'الْمُتَعَالِي',
    'transliteration': 'El-Müteali',
    'meaning': 'Yüceler yücesi',
  },
  {
    'arabic': 'الْبَرُّ',
    'transliteration': 'El-Berr',
    'meaning': 'İyilik eden',
  },
  {
    'arabic': 'التَّوَابُ',
    'transliteration': 'Et-Tevvab',
    'meaning': 'Tevbeyi kabul eden',
  },
  {
    'arabic': 'الْمُنْتَقِمُ',
    'transliteration': 'El-Muntakim',
    'meaning': 'İntikam alan',
  },
  {'arabic': 'العَفُوُّ', 'transliteration': 'El-Afuvv', 'meaning': 'Affeden'},
  {
    'arabic': 'الرَّؤُوفُ',
    'transliteration': 'Er-Rauf',
    'meaning': 'Çok şefkatli',
  },
  {
    'arabic': 'مَالِكُ الْمُلْكِ',
    'transliteration': 'Malikül-Mülk',
    'meaning': 'Mülkün sahibi',
  },
  {
    'arabic': 'ذُوالْجَلاَلِ وَالإكْرَامِ',
    'transliteration': 'Zül-Celali vel-İkram',
    'meaning': 'Celal ve ikram sahibi',
  },
  {
    'arabic': 'الْمُقْسِطُ',
    'transliteration': 'El-Muksıt',
    'meaning': 'Adil olan',
  },
  {'arabic': 'الْجَامِعُ', 'transliteration': 'El-Cami', 'meaning': 'Toplayan'},
  {
    'arabic': 'الْغَنِيُّ',
    'transliteration': 'El-Ganiyy',
    'meaning': 'Zengin olan',
  },
  {
    'arabic': 'الْمُغْنِي',
    'transliteration': 'El-Muğni',
    'meaning': 'Zengin eden',
  },
  {
    'arabic': 'اَلْمَانِعُ',
    'transliteration': 'El-Mani',
    'meaning': 'Engelleyen',
  },
  {
    'arabic': 'الضَّارَّ',
    'transliteration': 'Ed-Darr',
    'meaning': 'Zarar veren',
  },
  {
    'arabic': 'النَّافِعُ',
    'transliteration': 'En-Nafi',
    'meaning': 'Fayda veren',
  },
  {'arabic': 'النُّورُ', 'transliteration': 'En-Nur', 'meaning': 'Nur olan'},
  {
    'arabic': 'الْهَادِي',
    'transliteration': 'El-Hadi',
    'meaning': 'Hidayet veren',
  },
  {
    'arabic': 'الْبَدِيعُ',
    'transliteration': 'El-Bedi',
    'meaning': 'Eşsiz yaratan',
  },
  {
    'arabic': 'اَلْبَاقِي',
    'transliteration': 'El-Baki',
    'meaning': 'Sonsuz olan',
  },
  {
    'arabic': 'الْوَارِثُ',
    'transliteration': 'El-Varis',
    'meaning': 'Varis olan',
  },
  {
    'arabic': 'الرَّشِيدُ',
    'transliteration': 'Er-Reşid',
    'meaning': 'Doğru yolu gösteren',
  },
  {
    'arabic': 'الصَّبُورُ',
    'transliteration': 'Es-Sabur',
    'meaning': 'Sabırlı olan',
  },
];

/// Localize meaning string by index and current locale.
String _localizedNameMeaning(
  BuildContext context,
  int index,
  String meaningTr,
) {
  final lang = Localizations.localeOf(context).languageCode;
  if (lang != 'en') return meaningTr;
  const meaningsEn = <String>[
    'The Most Merciful',
    'The Especially Merciful',
    'The Absolute King',
    'The Most Holy, Pure and Perfect',
    'The Source of Peace and Perfection',
    'The Giver of Faith and Security',
    'The Overseer of all things',
    'The Almighty, All-Powerful',
    'The Compeller, Irresistible',
    'The Supreme in Greatness',
    'The Creator',
    'The Originator',
    'The Fashioner, Bestower of Forms',
    'The All-Forgiving',
    'The Subduer of all',
    'The Bestower, Ever-Giving',
    'The Provider of Sustenance',
    'The Opener, Granter of Victory',
    'The All-Knowing',
    'The Withholder, Restrainer',
    'The Expander',
    'The Abaser',
    'The Exalter',
    'The Bestower of Honor',
    'The Humiliator',
    'The All-Hearing',
    'The All-Seeing',
    'The Judge, Arbiter',
    'The Utterly Just',
    'The Subtle, Gentle',
    'The All-Aware',
    'The Forbearing, Clement',
    'The Magnificent',
    'The All-Forgiving',
    'The Appreciative',
    'The Most High, Exalted',
    'The Most Great',
    'The Preserver, Protector',
    'The Sustainer, Maintainer',
    'The Reckoner',
    'The Majestic',
    'The Generous, Noble',
    'The Watchful',
    'The Responsive',
    'The All-Encompassing, Vast',
    'The All-Wise',
    'The Loving',
    'The Most Glorious, Noble',
    'The Resurrector',
    'The Witness',
    'The Truth',
    'The Disposer of Affairs',
    'The All-Strong',
    'The Firm, Steadfast',
    'The Protecting Friend',
    'The Praiseworthy',
    'The Reckoner of all',
    'The Originator',
    'The Restorer',
    'The Giver of Life',
    'The Taker of Life',
    'The Ever-Living',
    'The Self-Sustaining',
    'The Finder, Rich',
    'The Noble, Majestic',
    'The One',
    'The Unique, One and Only',
    'The Eternal Refuge',
    'The All-Powerful',
    'The Omnipotent',
    'The Expediter, Bringer-Forward',
    'The Delayer, Postponer',
    'The First',
    'The Last',
    'The Manifest',
    'The Hidden',
    'The Patron, Guardian',
    'The Most High, Exalted',
    'The Most Benign, Source of Goodness',
    'The Accepter of Repentance',
    'The Avenger',
    'The Pardoning, Effacing',
    'The Most Kind, Compassionate',
    'Owner of the Dominion',
    'Possessor of Majesty and Honor',
    'The Equitable, Just',
    'The Gatherer',
    'The Self-Sufficient, Rich',
    'The Enricher',
    'The Preventer',
    'The Distresser',
    'The Benefactor',
    'The Light',
    'The Guide',
    'The Incomparable Originator',
    'The Everlasting',
    'The Inheritor',
    'The Guide to the Right Path',
    'The Patient, Enduring',
  ];
  if (index >= 0 && index < meaningsEn.length) {
    return meaningsEn[index];
  }
  return meaningTr;
}
