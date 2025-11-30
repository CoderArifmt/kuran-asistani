import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../l10n/app_localizations.dart';
import '../providers/app_providers.dart';

class MoreNearbyMosquesPage extends ConsumerWidget {
  const MoreNearbyMosquesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final posAsync = ref.watch(positionProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                // Header
                Container(
                  height: 56,
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.9),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      ),
                      Expanded(
                        child: Text(
                          l10n.nearbyMosquesTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF18181B),
                              ),
                        ),
                      ),
                      const SizedBox(width: 48, height: 48),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      Text(
                        l10n.closestMosques,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.nearbyMosquesDesc,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                          color: isDark
                              ? const Color(0xFFD1D5DB)
                              : const Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220,
                        child: posAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, _) =>
                              Center(child: Text('${l10n.locationError}: $e')),
                          data: (pos) => ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(
                                  pos.latitude,
                                  pos.longitude,
                                ),
                                initialZoom: 14,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName:
                                      'com.example.namaz_kuran_asistani',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(
                                        pos.latitude,
                                        pos.longitude,
                                      ),
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Color(0xFF14B866),
                                        size: 32,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      posAsync.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text('${l10n.nearbyMosquesLoading}: $e'),
                        ),
                        data: (pos) => FutureBuilder<List<_NearbyMosque>>(
                          future: _fetchNearbyMosques(pos),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  '${l10n.nearbyMosquesLoading}: ${snapshot.error}',
                                ),
                              );
                            }
                            final mosques = snapshot.data ?? const [];
                            if (mosques.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  l10n.noMosquesFound,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: isDark
                                            ? const Color(0xFF9CA3AF)
                                            : const Color(0xFF6B7280),
                                      ),
                                ),
                              );
                            }
                            return Column(
                              children: mosques.map((m) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _MosquePlaceholder(
                                    name: m.name,
                                    distance:
                                        '${m.distanceKm.toStringAsFixed(1)} km',
                                    onTap: () async {
                                      final uri = Uri.parse(
                                        'https://www.google.com/maps/search/?api=1&query=${m.lat},${m.lon}',
                                      );
                                      if (!await launchUrl(
                                        uri,
                                        mode: LaunchMode.externalApplication,
                                      )) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(l10n.mapError),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () async {
                          try {
                            final pos = await ref.read(positionProvider.future);
                            final uri = Uri.parse(
                              'https://www.google.com/maps/search/cami/@${pos.latitude},${pos.longitude},14z',
                            );
                            if (!await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            )) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.mapError)),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${l10n.locationError}: $e'),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.map),
                        label: Text(l10n.openInMap),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MosquePlaceholder extends StatelessWidget {
  const _MosquePlaceholder({
    required this.name,
    required this.distance,
    this.onTap,
  });

  final String name;
  final String distance;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF14B866).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.mosque, color: Color(0xFF14B866)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${l10n.distance}: $distance',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NearbyMosque {
  _NearbyMosque({
    required this.name,
    required this.lat,
    required this.lon,
    required this.distanceKm,
  });

  final String name;
  final double lat;
  final double lon;
  final double distanceKm;
}

Future<List<_NearbyMosque>> _fetchNearbyMosques(Position pos) async {
  final query =
      '[out:json];node(around:1500,${pos.latitude},${pos.longitude})[amenity=place_of_worship][religion=muslim];out;';
  final uri = Uri.parse(
    'https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}',
  );

  final response = await http
      .get(uri)
      .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Timeout connecting to mosque service');
        },
      );

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch nearby mosques: ${response.statusCode}');
  }

  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final elements = (data['elements'] as List<dynamic>?) ?? const [];
  final distance = const Distance();

  final mosques = elements.map((e) {
    final m = e as Map<String, dynamic>;
    final tags = (m['tags'] as Map<String, dynamic>?) ?? const {};
    final name = tags['name'] as String? ?? 'Cami';
    final lat = (m['lat'] as num).toDouble();
    final lon = (m['lon'] as num).toDouble();
    final dKm = distance.as(
      LengthUnit.Kilometer,
      LatLng(pos.latitude, pos.longitude),
      LatLng(lat, lon),
    );
    return _NearbyMosque(name: name, lat: lat, lon: lon, distanceKm: dKm);
  }).toList();

  mosques.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  return mosques.take(10).toList();
}
