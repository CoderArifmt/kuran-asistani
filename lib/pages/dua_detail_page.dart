import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class DuaDetailPage extends StatefulWidget {
  const DuaDetailPage({
    super.key,
    required this.duaId,
    required this.title,
    required this.subtitle,
    required this.audioUrl,
  });

  final String duaId;
  final String title;
  final String subtitle;
  final String audioUrl;

  @override
  State<DuaDetailPage> createState() => _DuaDetailPageState();
}

class _DuaLine {
  final String arabic;
  final String latin;
  final String turkish;

  const _DuaLine({
    required this.arabic,
    required this.latin,
    required this.turkish,
  });
}

class _DuaContent {
  final List<_DuaLine> lines;
  final String? note;

  const _DuaContent({required this.lines, this.note});
}

// Temel dualar için satır satır Arapça + Latin harflerle okunuş + Türkçe anlam.
// Not: Metinler örnek niteliğindedir; kendi tercih ettiğin mealleriyle güncelleyebilirsin.
const Map<String, _DuaContent> _duaContents = {
'subhaneke': _DuaContent(
    lines: [
      _DuaLine(
        arabic:
            'سُبْحَانَكَ اللّٰهُمَّ وَبِحَمْدِكَ، وَتَبَارَكَ اسْمُكَ، وَتَعَالٰى جَدُّكَ، وَلَا إِلٰهَ غَيْرُكَ',
        latin:
            'Subhâneke allâhumme ve bi hamdik, ve tebrake-smuk, ve teâlâ ceddük, ve lâ ilâhe ğayrük.',
        turkish:
            'Allah’ım! Seni hamdinle tesbih ederim. İsmin mübarektir, şanın yücedir, senden başka ilâh yoktur.',
      ),
    ],
  ),
  'ayetelkursi': _DuaContent(
    lines: [
      _DuaLine(
        arabic:
            'اَللّٰهُ لَا إِلٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ، لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ...',
        latin:
            'Allâhu lâ ilâhe illâ hüve’l-hayyü’l-kayyûm, lâ te’huzuhû sinetün ve lâ nevm(ün) ...',
        turkish:
            'Allah, kendisinden başka ilâh olmayan, hayy ve kayyûmdur. O’nu ne bir uyuklama ne de bir uyku tutar... (Bakara 255).',
      ),
    ],
  ),
  'tahiyyat': _DuaContent(
    lines: [
      _DuaLine(
        arabic:
            'اَلتَّحِيَّاتُ لِلّٰهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ، اَلسَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللّٰهِ وَبَرَكَاتُهُ',
        latin:
            'Et-tahiyyâtu lillâhi ves-salavâtu vet-tayyibât. Es-selâmu aleyke eyyühen-nebiyyü ve rahmetullâhi ve berakâtüh.',
        turkish:
            'Bütün selâmlar, namazlar ve güzel ibadetler Allah’a mahsustur. Ey Peygamber! Allah’ın selâmı, rahmeti ve bereketi senin üzerine olsun.',
      ),
      _DuaLine(
        arabic:
            'اَلسَّلَامُ عَلَيْنَا وَعَلٰى عِبَادِ اللّٰهِ الصَّالِحِينَ، اَشْهَدُ اَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَاَشْهَدُ اَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
        latin:
            'Es-selâmu aleynâ ve alâ ibâdillâhi s-sâlihîn. Eşhedü en lâ ilâhe illallâh ve eşhedü enne Muhammeden abdühû ve resûlüh.',
        turkish:
            'Selâm bizim ve Allah’ın sâlih kullarının üzerine olsun. Şehadet ederim ki Allah’tan başka ilâh yoktur, yine şehadet ederim ki Muhammed O’nun kulu ve elçisidir.',
      ),
    ],
  ),
  'salli_barik': _DuaContent(
    lines: [
      _DuaLine(
        arabic:
            'اَللّٰهُمَّ صَلِّ عَلٰى مُحَمَّدٍ وَعَلٰى اٰلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلٰى اِبْرٰهِيمَ وَعَلٰى اٰلِ اِبْرٰهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
        latin:
            'Allâhumme salli alâ Muhammedin ve alâ âli Muhammed, kemâ salleyte alâ İbrâhîme ve alâ âli İbrâhîm, inneke hamîdun mecîd.',
        turkish:
            'Allah’ım! İbrahim’e ve âline salât ettiğin gibi Muhammed’e ve âline de salât eyle. Şüphesiz Sen çok övülensin, çok şanlısın.',
      ),
      _DuaLine(
        arabic:
            'اَللّٰهُمَّ بَارِكْ عَلٰى مُحَمَّدٍ وَعَلٰى اٰلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلٰى اِبْرٰهِيمَ وَعَلٰى اٰلِ اِبْرٰهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
        latin:
            'Allâhumme bârik alâ Muhammedin ve alâ âli Muhammed, kemâ bârekte alâ İbrâhîme ve alâ âli İbrâhîm, inneke hamîdun mecîd.',
        turkish:
            'Allah’ım! İbrahim’e ve âline bereket verdiğin gibi Muhammed’e ve âline de bereket ver. Şüphesiz Sen çok övülensin, çok şanlısın.',
      ),
    ],
  ),
'rabbena': _DuaContent(
    lines: [
      _DuaLine(
        arabic:
            'رَبَّنَا اٰتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْاٰخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        latin:
            'Rabbena âtinâ fid-dünyâ haseneten ve fil-âhireti haseneten ve kinâ azâben-nâr.',
        turkish:
            'Ey Rabbimiz! Bize dünyada da iyilik ver, âhirette de iyilik ver ve bizi cehennem azabından koru.',
      ),
      _DuaLine(
        arabic:
            'رَبَّنَا ظَلَمْنَا أَنْفُسَنَا وَإِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ',
        latin:
            'Rabbena zalemnâ enfusenâ ve in lem tağfir lenâ ve terhamnâ le-nekûnenne minel-hâsirîn.',
        turkish:
            'Ey Rabbimiz! Biz kendimize zulmettik. Eğer bizi bağışlamaz ve bize merhamet etmezsen elbette ziyana uğrayanlardan oluruz.',
      ),
    ],
  ),
  'rabbi_yessir': _DuaContent(
    lines: [
      _DuaLine(
        arabic:
            'اَللّٰهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا وَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلًا',
        latin:
            'Allâhumme lâ sehle illâ mâ cealtehû sehlen ve ente tec’alu’l-hazne izâ şi’te sehlen.',
        turkish:
            'Allah’ım! Senin kolay kıldığından başka kolaylık yoktur. Dilediğin zaman üzüntü ve sıkıntıyı da kolaylaştırırsın.',
      ),
    ],
  ),
  'seyyidul_istigfar': _DuaContent(
    lines: [
      _DuaLine(
        arabic:
            'اَللّٰهُمَّ أَنْتَ رَبِّي لَا إِلٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ ...',
        latin:
            'Allâhumme ente rabbî lâ ilâhe illâ ente, halektenî ve ene abdük ...',
        turkish:
            'Allah’ım! Sen benim Rabbimsin, senden başka ilâh yok. Sen beni yarattın, ben Senin kulunum... (Seyyidü’l istiğfar duası).',
      ),
    ],
    note:
        'Bu dua sabah ve akşam okunması tavsiye edilen, istiğfarın en faziletlilerinden biri olarak bilinir.',
  ),
  'hasbunallah': _DuaContent(
    lines: [
      _DuaLine(
        arabic:
            'حَسْبُنَا اللّٰهُ وَنِعْمَ الْوَكِيلُ',
        latin:
            'Hasbunallâhu ve ni’mel-vekîl.',
        turkish:
            'Allah bize yeter, O ne güzel vekildir.',
      ),
    ],
  ),
};

class _DuaDetailPageState extends State<DuaDetailPage> {
  late final AudioPlayer _player;

  _DuaContent get _content =>
      _duaContents[widget.duaId] ?? const _DuaContent(lines: []);

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    // Oynatma durumu değiştiğinde (başladı, durdu, bitti) UI'yi güncelle
    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    // Zaten bu duayı dinliyorsak ve oynuyorsa durdur
    if (_player.playing) {
      try {
        await _player.stop();
      } catch (e, stackTrace) {
        debugPrint('Dua detail stop error: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
      if (mounted) setState(() {});
      return;
    }

    try {
      await _player.stop();
      await _player.setUrl(widget.audioUrl);
      await _player.play();
    } catch (e, stackTrace) {
      debugPrint('Dua detail play error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? const Color(0xFFD1D5DB)
                          : const Color(0xFF4B5563),
                    ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      isDark ? const Color(0xFF111827) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final line in _content.lines) ...[
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          line.arabic,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 22,
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        line.latin,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: isDark
                              ? const Color(0xFFD1D5DB)
                              : const Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        line.turkish,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: isDark
                              ? const Color(0xFFE5E7EB)
                              : const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (_content.note != null) ...[
                      Text(
                        _content.note!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: isDark
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF6B7280),
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0B1120)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 40,
                      onPressed: _togglePlay,
                      icon: Icon(
                        _player.playing
                            ? Icons.stop_circle
                            : Icons.play_circle_filled,
                      ),
                      color: const Color(0xFF14B866),
                    ),
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
