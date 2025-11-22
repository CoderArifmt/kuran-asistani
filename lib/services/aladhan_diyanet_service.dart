import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/prayer_times.dart';

class AladhanDiyanetService {
  static const _baseUrl = 'https://api.aladhan.com/v1';

  Future<PrayerTimes> fetchTodayByLocation({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/timings?latitude=$latitude&longitude=$longitude&method=13',
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception(
            'Namaz vakitleri servisine bağlanırken zaman aşımı oluştu');
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Namaz vakitleri alınamadı: ${response.statusCode}');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);
    return PrayerTimes.fromAladhan(json);
  }

  /// Belirli bir ay için tüm günlerin namaz vakitlerini döndürür.
  Future<List<PrayerTimes>> fetchMonthByLocation({
    required double latitude,
    required double longitude,
    required int month,
    required int year,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/calendar?latitude=$latitude&longitude=$longitude&method=13&month=$month&year=$year',
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception(
            'Namaz takvimi servisine bağlanırken zaman aşımı oluştu');
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Namaz takvimi alınamadı: ${response.statusCode}');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> days = json['data'] as List<dynamic>;

    return days
        .map((day) => PrayerTimes.fromAladhanDay(day as Map<String, dynamic>))
        .toList();
  }

  /// Şehir bilgisiyle aylık takvim.
  /// Aladhan API: /calendarByCity?city=Istanbul&country=Turkey&method=13&month=&year=
  Future<List<PrayerTimes>> fetchMonthByCity({
    required String country,
    required String city,
    String? district,
    required int month,
    required int year,
  }) async {
    final cityParam = district != null && district.isNotEmpty
        ? '$district, $city'
        : city;
    final uri = Uri.parse(
      '$_baseUrl/calendarByCity?city=$cityParam&country=$country&method=13&month=$month&year=$year',
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception(
            'Namaz takvimi servisine bağlanırken zaman aşımı oluştu');
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Namaz takvimi alınamadı: ${response.statusCode}');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> days = json['data'] as List<dynamic>;

    return days
        .map((day) => PrayerTimes.fromAladhanDay(day as Map<String, dynamic>))
        .toList();
  }
  /// Şehir bilgisiyle bugünkü namaz vakitleri.
  /// Aladhan API: /timingsByCity?city=Istanbul&country=Turkey&method=13
  Future<PrayerTimes> fetchTodayByCity({
    required String country,
    required String city,
    String? district,
  }) async {
    final cityParam = district != null && district.isNotEmpty
        ? '$district, $city'
        : city;
    final uri = Uri.parse(
      '$_baseUrl/timingsByCity?city=$cityParam&country=$country&method=13',
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception(
            'Namaz vakitleri servisine bağlanırken zaman aşımı oluştu');
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Namaz vakitleri alınamadı: ${response.statusCode}');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);
    return PrayerTimes.fromAladhan(json);
  }
}
