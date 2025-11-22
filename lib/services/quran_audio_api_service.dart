import 'dart:convert';

import 'package:http/http.dart' as http;

class QuranAudioApiService {
  /// Fetches audio URLs for each ayah of a given surah using api.alquran.cloud.
  ///
  /// Example endpoint: https://api.alquran.cloud/v1/surah/1/ar.alafasy
  Future<List<String>> fetchAyahAudioUrls(int surahNumber) async {
    final uri = Uri.parse(
        'https://api.alquran.cloud/v1/surah/$surahNumber/ar.alafasy');

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Ses verisi alınamadı (kod: ${response.statusCode})');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (decoded['data'] == null || decoded['data']['ayahs'] == null) {
      throw Exception('Beklenmeyen API cevabı');
    }

    final List<dynamic> ayahs = decoded['data']['ayahs'] as List<dynamic>;
    return ayahs
        .map((e) => (e as Map<String, dynamic>)['audio'] as String)
        .toList();
  }
}
