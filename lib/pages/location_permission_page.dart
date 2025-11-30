import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../l10n/app_localizations.dart';
import 'main_shell.dart';

class LocationPermissionPage extends StatefulWidget {
  const LocationPermissionPage({super.key});

  @override
  State<LocationPermissionPage> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> {
  bool _loading = false;
  String? _error;

  Future<void> _requestPermission() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      if (!mounted) return;
      final loc = AppLocalizations.of(context);
      
      // 1. Request Location Permission
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw loc.deviceLocationServiceOff;
      }

      var locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.denied) {
          throw loc.locationPermissionDenied;
        }
      }

      if (locationPermission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        throw loc.locationPermissionPermanentlyDenied;
      }

      // 2. Request Notification Permission
      final notificationStatus = await Permission.notification.request();
      if (!notificationStatus.isGranted) {
        // If denied, show an explanation. If permanently denied, guide to settings.
        if (notificationStatus.isPermanentlyDenied) {
          await openAppSettings();
          throw loc.notificationPermissionPermanentlyDenied;
        }
        throw loc.notificationPermissionRequired;
      }

      // 3. Both permissions granted, proceed to the app
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _skip() async {
    // Konum izni olmadan devam et: GPS sağlayamazsa sağlayıcılar IP tabanlı konuma düşecek.
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF112119) : const Color(0xFFF6F8F7),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF14B866).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.mosque_outlined,
                        size: 40,
                        color: Color(0xFF14B866),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).welcome,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 60,
                          color: cs.primary,
                        ),
                        const SizedBox(width: 24),
                        Icon(
                          Icons.notifications_active_rounded,
                          size: 60,
                          color: cs.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context).locationAndNotificationPermission,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context).locationAndNotificationPermissionDescription,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                            color: isDark
                                ? const Color(0xFFD1D5DB)
                                : const Color(0xFF4B5563),
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (_error != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cs.errorContainer.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cs.error,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: cs.surface.withValues(alpha: 0.9),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _loading ? null : _requestPermission,
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(AppLocalizations.of(context).grantPermissions),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _loading ? null : _skip,
                    child: Text(AppLocalizations.of(context).continueWithoutPermission),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
