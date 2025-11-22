import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class PrayerGuidePage extends StatelessWidget {
  const PrayerGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
                      AppLocalizations.of(context).prayerGuide,
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _prayerSteps.length,
                itemBuilder: (context, index) {
                  final locale = Localizations.localeOf(context).languageCode;
                  final step = _prayerSteps[index];
                  final title = locale == 'en'
                      ? (step['title_en'] ?? step['title']!)
                      : step['title']!;
                  final description = locale == 'en'
                      ? (step['description_en'] ?? step['description']!)
                      : step['description']!;
                  return _StepCard(
                    number: index + 1,
                    title: title,
                    description: description,
                    arabic: step['arabic'],
                    imageAsset: step['image'],
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

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.title,
    required this.description,
    this.arabic,
    this.imageAsset,
    required this.isDark,
  });

  final int number;
  final String title;
  final String description;
  final String? arabic;
  final String? imageAsset;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
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
                    '$number',
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
          if (imageAsset != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      imageAsset!,
                      fit: BoxFit.cover,
                      // Eğer asset bulunamazsa kırmızı hata kutusu yerine sade bir placeholder göster.
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: isDark
                              ? const Color(0xFF111827)
                              : const Color(0xFFE5E7EB),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                              color: isDark ? Colors.white60 : Colors.black45,
                            ),
                          ),
                        );
                      },
                    ),
                    if (isDark)
                      Container(color: Colors.black.withValues(alpha: 0.25)),
                  ],
                ),
              ),
            ),
          ],
          if (arabic != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF14B866).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                arabic!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14B866),
                  height: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, String?>> _prayerSteps = [
  {
    'title': 'Niyet',
    'title_en': 'Intention (Niyyah)',
    'description':
        'Kılacağınız namazın niyetini içinizden yapın. Örn: "Bugünün farz sabah namazını kılmaya niyet ettim."',
    'description_en':
        'Make the intention for the prayer in your heart. For example: "I intend to pray today\'s obligatory Fajr prayer."',
    'arabic': null,
    'image': 'assets/prayer_guide/01_niyet.png',
  },
  {
    'title': 'İftitah Tekbiri',
    'title_en': 'Opening Takbir (Takbirat al-Ihram)',
    'description':
        'Ellerinizi kulaklarınıza kadar kaldırarak "Allahu Ekber" deyin ve elleri göbeğin altında bağlayın.',
    'description_en':
        'Raise your hands up to your ears and say "Allahu Akbar", then fold your hands below the navel.',
    'arabic': 'اَللّٰهُ اَكْبَرُ',
    'image': 'assets/prayer_guide/02_iftitah_tekbiri.png',
  },
  {
    'title': 'Sübhaneke Duası',
    'title_en': 'Subhanaka Dua',
    'description': 'Ayakta durarak Sübhaneke duasını okuyun.',
    'description_en': 'While standing, recite the Subhanaka supplication.',
    'arabic': 'سُبْحَانَكَ اللّٰهُمَّ وَبِحَمْدِكَ',
    'image': 'assets/prayer_guide/03_subhaneke.png',
  },
  {
    'title': 'Euzü-Besmele',
    'title_en': 'Ta\'awwudh and Basmala',
    'description':
        'Euzü Besmele\'yi okuyun: "Euzü billahi mineşşeytanirracim, Bismillahirrahmanirrahim"',
    'description_en':
        'Recite Ta\'awwudh and Basmala: "A\'udhu billahi minash-shaytanir-rajim, Bismillahir-Rahmanir-Rahim".',
    'arabic': 'اَعُوذُ بِاللّٰهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
    'image': 'assets/prayer_guide/04_euzu_besmele.png',
  },
  {
    'title': 'Fatiha Suresi',
    'title_en': 'Surah Al-Fatiha',
    'description': 'Fatiha suresini okuyun.',
    'description_en': 'Recite Surah al-Fatiha.',
    'arabic': 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيمِ',
    'image': 'assets/prayer_guide/05_fatiha.png',
  },
  {
    'title': 'Zamm-ı Sure',
    'title_en': 'Additional Surah (or Verses)',
    'description': 'Fatiha\'dan sonra kısa bir sure veya en az 3 ayet okuyun.',
    'description_en':
        'After al-Fatiha, recite a short surah or at least three verses from the Qur\'an.',
    'arabic': null,
    'image': 'assets/prayer_guide/06_zammi_sure.png',
  },
  {
    'title': 'Rükû',
    'title_en': 'Ruku (Bowing)',
    'description':
        '"Allahu Ekber" diyerek rükûya eğilin. Sırtınızı düz tutun ve "Sübhane Rabbiyel Azim" deyin (3 kez).',
    'description_en':
        'Say "Allahu Akbar" and bow into ruku. Keep your back straight and say "Subhana Rabbiyal Azim" three times.',
    'arabic': 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
    'image': 'assets/prayer_guide/07_ruku.png',
  },
  {
    'title': 'Rükûdan Kalkış',
    'title_en': 'Standing up from Ruku',
    'description':
        '"Semiallahu limen hamideh" diyerek doğrulun. Ardından "Rabbena leke\'l-hamd" deyin.',
    'description_en':
        'Rise saying "Sami\'allahu liman hamidah". Then say "Rabbana wa lakal-hamd".',
    'arabic': 'سَمِعَ اللّٰهُ لِمَنْ حَمِدَهُ',
    'image': 'assets/prayer_guide/08_rukudan_kalkis.png',
  },
  {
    'title': 'Secde',
    'title_en': 'Sujood (Prostration)',
    'description':
        '"Allahu Ekber" diyerek secdeye kapanın. Alnınız, burnunuz, eller, dizler ve ayak parmakları yere değmeli. "Sübhane Rabbiyel A\'la" deyin (3 kez).',
    'description_en':
        'Say "Allahu Akbar" and go into sujood. Your forehead, nose, hands, knees and toes should touch the ground. Say "Subhana Rabbiyal A\'la" three times.',
    'arabic': 'سُبْحَانَ رَبِّيَ الْاَعْلٰى',
    'image': 'assets/prayer_guide/09_secdeler.png',
  },
  {
    'title': 'İki Secde Arası',
    'title_en': 'Between the Two Sujoods',
    'description':
        '"Allahu Ekber" diyerek secdeden kalkın ve kısa bir süre oturun.',
    'description_en':
        'Say "Allahu Akbar" and rise from sujood to sit briefly between the two prostrations.',
    'arabic': null,
    'image': 'assets/prayer_guide/10_iki_secdeler_arasi_oturus.png',
  },
  {
    'title': 'İkinci Secde',
    'title_en': 'Second Sujood',
    'description':
        'Tekrar "Allahu Ekber" diyerek secdeye kapanın ve "Sübhane Rabbiyel A\'la" deyin (3 kez).',
    'description_en':
        'Once again say "Allahu Akbar" and go into sujood, reciting "Subhana Rabbiyal A\'la" three times.',
    'arabic': 'سُبْحَانَ رَبِّيَ الْاَعْلٰى',
    'image': 'assets/prayer_guide/11_ikinci_secdeler.png',
  },
  {
    'title': 'İkinci Rekat',
    'title_en': 'Second Rakat',
    'description':
        'İkinci rekat için ayağa kalkın ve aynı adımları tekrarlayın (Fatiha, sure, rükû, secde).',
    'description_en':
        'Stand up for the second rakat and repeat the same steps (Fatiha, another surah, ruku and sujood).',
    'arabic': null,
    'image': 'assets/prayer_guide/12_ikinci_rekat.png',
  },
  {
    'title': 'Ka\'de (Oturuş)',
    'title_en': 'Final Sitting (Tashahhud)',
    'description':
        'İkinci rekatta secdeden sonra oturun. Ettehiyyatü, Allahumme Salli, Allahumme Barik ve Rabbena dualarını okuyun.',
    'description_en':
        'After the sujood of the final rakat, sit and recite the Tashahhud (Attahiyyat), Allahumma Salli, Allahumma Barik and Rabbana duas.',
    'arabic': 'اَلتَّحِيَّاتُ لِلّٰهِ',
    'image': 'assets/prayer_guide/13_kade_oturus.png',
  },
  {
    'title': 'Selam Verme',
    'title_en': 'Ending the Prayer (Salam)',
    'description':
        'Önce sağa "Esselamu aleyküm ve rahmetullah", sonra sola aynı şekilde selam verin.',
    'description_en':
        'Turn your head to the right and say "As-salamu alaykum wa rahmatullah", then to the left and repeat the same.',
    'arabic': 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللّٰهِ',
    'image': 'assets/prayer_guide/14_salam.png',
  },
];
