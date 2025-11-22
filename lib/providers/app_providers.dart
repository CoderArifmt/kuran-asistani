import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../models/prayer_times.dart';
import '../services/location_service.dart';
import '../services/aladhan_diyanet_service.dart';
import '../services/geocoding_service.dart';
import '../services/favorites_service.dart';
import '../services/ip_location_service.dart';
import '../core/api/quran_api_service.dart';
import '../core/models/surah.dart';
import '../core/models/ayah.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final ipLocationServiceProvider = Provider<IpLocationService>((ref) {
  return IpLocationService();
});

final aladhanServiceProvider = Provider<AladhanDiyanetService>((ref) {
  return AladhanDiyanetService();
});

final geocodingServiceProvider = Provider<GeocodingService>((ref) {
  return GeocodingService();
});

final positionProvider = FutureProvider<Position>((ref) async {
  final locationService = ref.read(locationServiceProvider);
  return locationService.getCurrentPosition();
});

/// IP tabanlı yaklaşık konum.
final ipLocationProvider = FutureProvider<IpLocation?>((ref) async {
  final service = ref.read(ipLocationServiceProvider);
  return service.getLocation();
});

/// Önce GPS, gerekirse IP fallback ile bugünün namaz vakitleri.
/// Cache enabled for better performance
final todayPrayerTimesProvider = FutureProvider<PrayerTimes>((ref) async {
  // Keep provider alive to avoid unnecessary refetches
  ref.keepAlive();
  
  final service = ref.read(aladhanServiceProvider);

  double lat;
  double lon;

  try {
    final pos = await ref.watch(positionProvider.future);
    lat = pos.latitude;
    lon = pos.longitude;
  } catch (_) {
    final ipLoc = await ref.watch(ipLocationProvider.future);
    if (ipLoc == null) {
      throw Exception('Konum GPS veya IP ile tespit edilemedi');
    }
    lat = ipLoc.latitude;
    lon = ipLoc.longitude;
  }

  return service.fetchTodayByLocation(
    latitude: lat,
    longitude: lon,
  );
});

/// Gösterilen şehir adı: önce geocoding, gerekirse IP ile şehir.
/// Cache enabled for performance
final cityNameProvider = FutureProvider<String>((ref) async {
  ref.keepAlive();
  
  try {
    final pos = await ref.watch(positionProvider.future);
    final geocoding = ref.read(geocodingServiceProvider);
    return geocoding.getCityName(
      latitude: pos.latitude,
      longitude: pos.longitude,
    );
  } catch (_) {
    final ipLoc = await ref.watch(ipLocationProvider.future);
    if (ipLoc != null) {
      final city = ipLoc.city.trim();
      final code = ipLoc.countryCode.trim();
      if (city.isNotEmpty || code.isNotEmpty) {
        final parts = <String>[];
        if (city.isNotEmpty) parts.add(city);
        if (code.isNotEmpty) parts.add(code);
        return parts.join(' ');
      }
    }
    return 'Bilinmeyen konum';
  }
});

final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  return FavoritesService();
});

final favoriteDuaIdsProvider = FutureProvider<Set<String>>((ref) async {
  ref.keepAlive();
  final service = ref.read(favoritesServiceProvider);
  return service.getFavoriteDuaIds();
});

final favoriteSurahNumbersProvider =
    FutureProvider<Set<int>>((ref) async {
  ref.keepAlive();
  final service = ref.read(favoritesServiceProvider);
  return service.getFavoriteSurahNumbers();
});

/// Belirli bir ay için namaz takvimi (GPS + IP fallback).
final monthlyPrayerTimesProvider =
    FutureProvider.family<List<PrayerTimes>, DateTime>((ref, monthBase) async {
  final service = ref.read(aladhanServiceProvider);

  double lat;
  double lon;

  try {
    final pos = await ref.watch(positionProvider.future);
    lat = pos.latitude;
    lon = pos.longitude;
  } catch (_) {
    final ipLoc = await ref.watch(ipLocationProvider.future);
    if (ipLoc == null) {
      throw Exception('Aylık takvim için konum tespit edilemedi');
    }
    lat = ipLoc.latitude;
    lon = ipLoc.longitude;
  }

  return service.fetchMonthByLocation(
    latitude: lat,
    longitude: lon,
    month: monthBase.month,
    year: monthBase.year,
  );
});

final quranApiServiceProvider = Provider<QuranApiService>((ref) {
  return QuranApiService();
});

/// Tüm sureler (AlQuran Cloud /surah)
/// Cache enabled - surah list doesn't change
final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  ref.keepAlive();
  final service = ref.read(quranApiServiceProvider);
  return service.getSurahList();
});

/// Seçili sure detayı (Arapça + Türkçe meal + her ayet için audio URL)
final surahDetailProvider =
    FutureProvider.family<SurahDetail, int>((ref, surahNumber) async {
  final service = ref.read(quranApiServiceProvider);
  return service.getSurahDetail(surahNumber);
});
