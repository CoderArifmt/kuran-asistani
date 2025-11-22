import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/surah.dart';
import '../models/ayah.dart';

class QuranApiService {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';

  Future<List<Surah>> getSurahList() async {
    final uri = Uri.parse('$_baseUrl/surah');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch surah list (status: ${response.statusCode})');
    }

    final Map<String, dynamic> jsonBody =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (jsonBody['status'] != 'OK') {
      throw Exception('API hatası: ${jsonBody['data']}');
    }

    final List<dynamic> data = jsonBody['data'] as List<dynamic>;
    return data.map((e) => Surah.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SurahDetail> getSurahDetail(int surahNumber) async {
    try {
      final arabicUri = Uri.parse('$_baseUrl/surah/$surahNumber');
      final turkishUri = Uri.parse('$_baseUrl/surah/$surahNumber/tr.diyanet');

      final responses = await Future.wait([
        http.get(arabicUri),
        http.get(turkishUri),
      ]);

      final arabicRes = responses[0];
      final turkishRes = responses[1];
      if (arabicRes.statusCode != 200) {
        throw Exception(
            'Arabic surah details could not be fetched (status: ${arabicRes.statusCode})');
      }
      if (turkishRes.statusCode != 200) {
        throw Exception(
            'Turkish surah translation could not be fetched (status: ${turkishRes.statusCode})');
      }

      final arabicJson =
          jsonDecode(arabicRes.body) as Map<String, dynamic>;
      final turkishJson =
          jsonDecode(turkishRes.body) as Map<String, dynamic>;

      if (arabicJson['status'] != 'OK' || turkishJson['status'] != 'OK') {
        throw Exception('API status error (status != OK)');
      }

      final arabicData = arabicJson['data'] as Map<String, dynamic>;
      final turkishData = turkishJson['data'] as Map<String, dynamic>;

      final List<dynamic> arabicAyahs =
          arabicData['ayahs'] as List<dynamic>;
      final List<dynamic> turkishAyahs =
          turkishData['ayahs'] as List<dynamic>;

      final Map<int, String> trByNumberInSurah = {
        for (final e in turkishAyahs)
          (e as Map<String, dynamic>)['numberInSurah'] as int:
              (e)['text'] as String,
      };

      final List<Ayah> ayahs = arabicAyahs.map((e) {
        final map = e as Map<String, dynamic>;
        final int numberInSurah = map['numberInSurah'] as int;
        final String textAr = map['text'] as String;
        final int globalNumber = map['number'] as int;

        final String? trText = trByNumberInSurah[numberInSurah];

        final String audioUrl =
            'https://cdn.islamic.network/quran/audio/64/ar.alafasy/$globalNumber.mp3';

        return Ayah(
          numberInSurah: numberInSurah,
          text: textAr,
          translationText: trText,
          audioUrl: audioUrl,
        );
      }).toList();

      return SurahDetail(
        surahNumber: surahNumber,
        surahNameArabic: arabicData['name'] as String? ?? '',
        surahNameEnglish: arabicData['englishName'] as String? ?? 'Surah $surahNumber',
        ayahs: ayahs,
      );
    } catch (e) {
      throw Exception('Error while fetching surah detail: $e');
    }
  }
}
