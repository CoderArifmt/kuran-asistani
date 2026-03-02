import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_shell.dart';
import 'welcome_page.dart';

class StitchSplashScreen extends StatefulWidget {
  const StitchSplashScreen({super.key});

  @override
  State<StitchSplashScreen> createState() => _StitchSplashScreenState();
}

class _StitchSplashScreenState extends State<StitchSplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleStartupFlow();
  }

  Future<void> _handleStartupFlow() async {
    final prefs = await SharedPreferences.getInstance();
    final seenWelcome = prefs.getBool('seen_welcome') ?? false;

    // Check location permissions directly without delay
    final hasLocation = await _checkLocationPermissions();

    if (!mounted) return;

    // Eğer hoş geldin ekranını görmediyse veya konum izni yoksa
    if (!seenWelcome || !hasLocation) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const StitchWelcomePage()),
      );
      return;
    }

    // Konum izni var ve hoş geldin ekranı görüldüyse -> Ana Shell
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
  }

  Future<bool> _checkLocationPermissions() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();
      return serviceEnabled &&
          (permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cihaz dilini al (tr ise Türkçe Başlık, değilse İngilizce Başlık)
    final String deviceLanguage =
        ui.PlatformDispatcher.instance.locale.languageCode;
    final String appTitle = deviceLanguage == 'tr'
        ? 'Namaz ve Kur\'an Asistanı'
        : 'Prayer & Quran Assistant';

    // Referans görsele göre renk paleti
    // Referans görsele göre renk paleti
    const bgTop = Color(0xFF020F0A);
    const bgBottom = Color(0xFF071B14);
    const primaryGreen = Color(0xFF19E680);
    const ringGreen = Color(0xFF148F54);
    const mutedGreen = Color(0xFF93C8AD);

    return Scaffold(
      // Arka plan: üstten alta hafif degrade koyu yeşil
      backgroundColor: bgBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: Stack(
          children: [
            // Ortada icon + başlık
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Center(
                      child: Icon(
                        Icons.mosque_outlined,
                        size: 96,
                        color: primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    appTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Alt kısımda yükleniyor indicator + versiyon
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: const AlwaysStoppedAnimation(primaryGreen),
                        backgroundColor: ringGreen.withValues(alpha: 0.25),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'v1.0.0',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        color: mutedGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
