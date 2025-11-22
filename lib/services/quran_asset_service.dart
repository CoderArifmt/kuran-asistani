import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class SurahSummary {
  final int number;
  final String nameAr;
  final String nameEn;
  final String nameTr;
  final String revelationType;
  final int ayahCount;

  SurahSummary({
    required this.number,
    required this.nameAr,
    required this.nameEn,
    required this.nameTr,
    required this.revelationType,
    required this.ayahCount,
  });

  factory SurahSummary.fromJson(Map<String, dynamic> json) {
    return SurahSummary(
      number: json['number'] as int,
      nameAr: json['name'] as String,
      nameEn: json['englishName'] as String,
      nameTr: json['turkishName'] as String,
      revelationType: json['revelationType'] as String,
      ayahCount: json['ayahCount'] as int,
    );
  }
}

class Ayah {
  final int number;
  final int numberInSurah;
  final String textAr;
  final String textTr;

  Ayah({
    required this.number,
    required this.numberInSurah,
    required this.textAr,
    required this.textTr,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'] as int,
      numberInSurah: json['numberInSurah'] as int,
      textAr: json['textAr'] as String,
      textTr: json['textTr'] as String,
    );
  }
}

class SurahDetail {
  final int surahNumber;
  final List<Ayah> ayahs;

  SurahDetail({required this.surahNumber, required this.ayahs});

  factory SurahDetail.fromJson(Map<String, dynamic> json) {
    final list = json['ayahs'] as List<dynamic>;
    return SurahDetail(
      surahNumber: json['surahNumber'] as int,
      ayahs: list
          .map((e) => Ayah.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QuranAssetService {
  Future<List<SurahSummary>> loadSurahSummaries() async {
    final raw = await rootBundle.loadString('assets/quran/surahs.json');
    final List<dynamic> data = jsonDecode(raw);
    return data
        .map((e) => SurahSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<SurahDetail> loadSurahDetail(int surahNumber) async {
    final path = 'assets/quran/surah_$surahNumber.json';
    final raw = await rootBundle.loadString(path);
    final Map<String, dynamic> json = jsonDecode(raw);
    return SurahDetail.fromJson(json);
  }
}
