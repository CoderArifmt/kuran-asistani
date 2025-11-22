import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class HajjUmrahGuidePage extends StatelessWidget {
  const HajjUmrahGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
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
                        AppLocalizations.of(context).hajjUmrahGuide,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Builder(
                builder: (context) => TabBar(
                  tabs: [
                    Tab(text: AppLocalizations.of(context).umrah),
                    Tab(text: AppLocalizations.of(context).hajj),
                  ],
                  labelColor: const Color(0xFF14B866),
                  indicatorColor: const Color(0xFF14B866),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _GuideList(steps: _umrahSteps),
                    _GuideList(steps: _hajjSteps),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuideList extends StatelessWidget {
  const _GuideList({required this.steps});

  final List<Map<String, String>> steps;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final locale = Localizations.localeOf(context).languageCode;
        final step = steps[index];
        final title = locale == 'en'
            ? (step['title_en'] ?? step['title']!)
            : step['title']!;
        final description = locale == 'en'
            ? (step['description_en'] ?? step['description']!)
            : step['description']!;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14B866),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: isDark
                      ? const Color(0xFFD1D5DB)
                      : const Color(0xFF374151),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

final List<Map<String, String>> _umrahSteps = [
  {
    'title': 'Mîkat',
    'title_en': 'Miqat (Boundary Point)',
    'description':
        'Umreye başlamadan önce Mîkat sınırından önce ihrama girin. Erkekler için 2 parça beyaz kumaş, kadınlar normal giysi giyerler.',
    'description_en':
        'Before starting Umrah, enter into ihram before crossing the Miqat boundary. Men wear two white pieces of cloth, women wear modest normal clothing.',
  },
  {
    'title': 'Niyet ve Telbiye',
    'title_en': 'Intention and Talbiyah',
    'description':
        'İhrama girdikten sonra umre niyetiyle Telbiye getirin: "Lebbeyk Allahumme Umraten"',
    'description_en':
        'After entering ihram, make the intention for Umrah and recite the Talbiyah: "Labbayk Allahumma Umratan".',
  },
  {
    'title': 'Kâbe\'yi Tavaf',
    'title_en': 'Tawaf of the Kaaba',
    'description':
        'Mescid-i Haram\'a girip Hacer-i Esved\'den başlayarak Kâbe\'yi 7 kez tavaf edin. Erkekler ilk 3 turda omuz açar ve hızlı yürürler.',
    'description_en':
        'Enter Masjid al-Haram and begin Tawaf from the Black Stone, circling the Kaaba seven times. Men uncover the right shoulder and walk briskly in the first three rounds.',
  },
  {
    'title': 'Makam-ı İbrahim\'de Namaz',
    'title_en': 'Prayer at Maqam Ibrahim',
    'description':
        'Tavaftan sonra mümkünse Makam-ı İbrahim arkasında 2 rekat namaz kılın.',
    'description_en':
        'After Tawaf, if possible, pray two rakats behind Maqam Ibrahim.',
  },
  {
    'title': 'Zemzem Suyu',
    'title_en': 'Zamzam Water',
    'description':
        'Tavaf namazından sonra Zemzem suyu için. Dilediğiniz duaları yapabilirsiniz.',
    'description_en':
        'After the Tawaf prayer, drink Zamzam water and make personal duas.',
  },
  {
    'title': 'Sa\'y',
    'title_en': 'Sa\'y between Safa and Marwa',
    'description':
        'Safa tepesinden başlayarak Safa ile Merve arasında 7 kez gidip gelin (sa\'y). Yeşil işaretler arasında erkekler koşar.',
    'description_en':
        'Starting from Safa, walk between Safa and Marwa seven times for Sa\'y. Men jog between the green markers.',
  },
  {
    'title': 'Saç Kesme/Traş',
    'title_en': 'Cutting or Shaving the Hair',
    'description':
        'Sa\'yden sonra erkekler saçlarını kısaltır veya traş olur, kadınlar saçlarının ucundan parmak ucu kadar keser. Bu ile umre tamamlanır ve ihramdan çıkılır.',
    'description_en':
        'After Sa\'y, men either shorten or shave their hair; women cut a fingertip length from their hair. This completes the Umrah and you exit ihram.',
  },
];

final List<Map<String, String>> _hajjSteps = [
  {
    'title': 'İhram',
    'title_en': 'Ihram',
    'description':
        '8 Zilhicce\'de (Terviye günü) Mekke\'de ihrama girin ve hac niyeti yapın. Telbiye getirin.',
    'description_en':
        'On the 8th of Dhul-Hijjah (Day of Tarwiyah), enter ihram in Makkah with the intention for Hajj and recite the Talbiyah.',
  },
  {
    'title': 'Mina\'ya Gidiş',
    'title_en': 'Going to Mina',
    'description':
        'Öğle namazından sonra Mina\'ya gidin. Burada öğle, ikindi, akşam, yatsı ve sabah namazlarını kılın.',
    'description_en':
        'After Dhuhr, go to Mina. Pray Dhuhr, Asr, Maghrib, Isha and Fajr there.',
  },
  {
    'title': 'Arafat',
    'title_en': 'Arafat',
    'description':
        '9 Zilhicce (Arefe günü) sabah namazından sonra Arafat\'a gidin. Öğle ile ikindi namazını cem ederek kılın. Gün batımına kadar Arafat\'ta kalıp dua edin.',
    'description_en':
        'On the 9th of Dhul-Hijjah (Day of Arafah), after Fajr go to Arafat. Combine and shorten Dhuhr and Asr and spend the day making dua until sunset.',
  },
  {
    'title': 'Müzdelife',
    'title_en': 'Muzdalifah',
    'description':
        'Güneş battıktan sonra Müzdelife\'ye gidin. Akşam ve yatsı namazını cem ederek kılın. Sabaha kadar Müzdelife\'de kalın ve şeytan taşlamak için 70 çakıl taşı toplayın.',
    'description_en':
        'After sunset, go to Muzdalifah. Combine Maghrib and Isha there, spend the night, and collect about 70 pebbles for stoning the Jamarat.',
  },
  {
    'title': 'Cemre-i Akabe',
    'title_en': 'Jamarat al-Aqabah',
    'description':
        '10 Zilhicce (Kurban Bayramı) sabah namazından sonra Mina\'ya dönün. Cemre-i Akabe\'ye (büyük şeytan) 7 taş atın.',
    'description_en':
        'On the 10th of Dhul-Hijjah (Eid day), after Fajr return to Mina and stone Jamarat al-Aqabah (the big Jamarah) with seven pebbles.',
  },
  {
    'title': 'Kurban',
    'title_en': 'Sacrifice (Qurban)',
    'description': 'Kurban kesin veya vekil tayin edin. Bu farz ibadettir.',
    'description_en':
        'Offer the sacrificial animal yourself or appoint a representative. This is an obligatory rite of Hajj.',
  },
  {
    'title': 'Saç Kesme/Traş',
    'title_en': 'Cutting or Shaving the Hair',
    'description':
        'Erkekler traş olur veya saç kısaltır, kadınlar parmak ucu kadar keser.',
    'description_en':
        'Men shave or shorten their hair; women cut a small portion from the ends of their hair.',
  },
  {
    'title': 'Tavaf-ı Ziyaret',
    'title_en': 'Tawaf az-Ziyarah (Main Tawaf)',
    'description':
        'Mekke\'ye gidip Kâbe\'yi 7 kez tavaf edin. Bu haccın farzlarındandır.',
    'description_en':
        'Go to Makkah and perform Tawaf az-Ziyarah, circling the Kaaba seven times. This is a pillar of Hajj.',
  },
  {
    'title': 'Sa\'y',
    'title_en': 'Sa\'y between Safa and Marwa',
    'description': 'Safa ile Merve arasında 7 kez sa\'y yapın.',
    'description_en':
        'Perform Sa\'y, walking between Safa and Marwa seven times.',
  },
  {
    'title': 'Teşrik Günleri',
    'title_en': 'Days of Tashreeq',
    'description':
        '11, 12 ve 13 Zilhicce günlerinde Mina\'da kalın ve her gün üç cemreye (küçük, orta, büyük şeytan) 7\'er taş atın.',
    'description_en':
        'During the 11th, 12th and 13th of Dhul-Hijjah, stay in Mina and stone all three Jamarat (small, middle, large) with seven pebbles each day.',
  },
  {
    'title': 'Tavaf-ı Veda',
    'title_en': 'Farewell Tawaf (Tawaf al-Wada)',
    'description':
        'Mekke\'den ayrılmadan önce veda tavafı yapın. Bu vaciptir. Hayızlı ve nifaslı kadınlardan düşer.',
    'description_en':
        'Before leaving Makkah, perform the Farewell Tawaf. This is wajib, but it is waived for women in menstruation or postnatal bleeding.',
  },
];
