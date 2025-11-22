import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class IpLocation {
  final double latitude;
  final double longitude;
  final String city;
  final String country;
  final String countryCode;

  IpLocation({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.countryCode,
  });
}

class IpLocationService {
  Future<IpLocation?> getLocation() async {
    try {
      final uri = Uri.parse('https://ipwho.is/');
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        debugPrint('IP konum isteği başarısız: ${response.statusCode}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // success false dönebilir, kontrol edelim
      if (data['success'] == false) {
        debugPrint('IP konum servisi başarısız: ${data['message']}');
        return null;
      }

      final lat = (data['latitude'] as num?)?.toDouble();
      final lon = (data['longitude'] as num?)?.toDouble();
      final city = (data['city'] as String?) ?? '';
      final country = (data['country'] as String?) ?? '';
      final countryCode =
          ((data['country_code'] as String?) ?? '').toUpperCase().trim();

      if (lat == null || lon == null) {
        return null;
      }

      return IpLocation(
        latitude: lat,
        longitude: lon,
        city: city,
        country: country,
        countryCode: countryCode,
      );
    } catch (e) {
      debugPrint('IP konum hatası: $e');
      return null;
    }
  }
}
