import 'package:geocoding/geocoding.dart';

class GeocodingService {
  /// İl, ilçe ve ülke kodunu birleştirerek tek satırlık konum etiketi döner.
  /// Örn: "İstanbul Kartal TR" veya "California San Francisco US".
  Future<String> getCityName({
    required double latitude,
    required double longitude,
  }) async {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isEmpty) {
      throw Exception('Konumdan şehir adı çözümlenemedi');
    }

    final place = placemarks.first;
    final province = (place.administrativeArea ?? '').trim();
    final districtCandidate =
        (place.subAdministrativeArea ?? place.locality ?? '').trim();
    final countryCode = (place.isoCountryCode ?? '').toUpperCase().trim();

    final parts = <String>[];
    if (province.isNotEmpty) {
      parts.add(province);
    }
    if (districtCandidate.isNotEmpty && districtCandidate != province) {
      parts.add(districtCandidate);
    }
    if (countryCode.isNotEmpty) {
      parts.add(countryCode);
    }

    if (parts.isEmpty) {
      return 'Bilinmeyen konum';
    }
    return parts.join(' ');
  }
}
