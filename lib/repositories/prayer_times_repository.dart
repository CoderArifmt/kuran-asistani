import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prayer_times.dart';

class PrayerTimesRepository {
  // Aladhan API endpoint for today's prayer times (city: Istanbul, method: 2)
  static const String _baseUrl = 'https://api.aladhan.com/v1/timingsByCity';

  /// Fetches prayer times for the current date.
  /// Returns a [PrayerTimes] instance or throws an exception on failure.
  Future<PrayerTimes> fetchToday({
    String city = 'Istanbul',
    String country = 'Turkey',
    int method = 2,
  }) async {
    final now = DateTime.now();
    final dateStr = '${now.day}-${now.month}-${now.year}';
    final uri = Uri.parse(
      '$_baseUrl?city=$city&country=$country&method=$method&date=$dateStr',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch prayer times: ${response.statusCode}');
    }
    final Map<String, dynamic> json = jsonDecode(response.body);
    return PrayerTimes.fromAladhan(json);
  }
}
