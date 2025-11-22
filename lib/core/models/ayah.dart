class Ayah {
  final int numberInSurah;
  final String text; // Arabic
  final String? translationText; // Turkish translation if available
  final String? audioUrl; // audio URL for this ayah if available

  Ayah({
    required this.numberInSurah,
    required this.text,
    this.translationText,
    this.audioUrl,
  });

  Ayah copyWith({
    int? numberInSurah,
    String? text,
    String? translationText,
    String? audioUrl,
  }) {
    return Ayah(
      numberInSurah: numberInSurah ?? this.numberInSurah,
      text: text ?? this.text,
      translationText: translationText ?? this.translationText,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }
}

class SurahDetail {
  final int surahNumber;
  final String surahNameArabic;
  final String surahNameEnglish;
  final List<Ayah> ayahs;

  SurahDetail({
    required this.surahNumber,
    required this.surahNameArabic,
    required this.surahNameEnglish,
    required this.ayahs,
  });
}
