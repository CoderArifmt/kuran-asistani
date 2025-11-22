import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../providers/app_providers.dart';
import '../l10n/app_localizations.dart';
import 'location_permission_page.dart';

class StitchQiblaPage extends ConsumerWidget {
  const StitchQiblaPage({super.key});

  double _calculateQiblaBearing(Position pos) {
    const kaabaLat = 21.422487 * pi / 180; // Kâbe koordinatları
    const kaabaLon = 39.826206 * pi / 180;
    final latRad = pos.latitude * pi / 180;
    final lonRad = pos.longitude * pi / 180;
    final dLon = kaabaLon - lonRad;

    final y = sin(dLon);
    final x = cos(latRad) * tan(kaabaLat) - sin(latRad) * cos(dLon);
    final bearing = atan2(y, x);
    final bearingDeg = (bearing * 180 / pi + 360) % 360;
    return bearingDeg;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              color: cs.surface.withValues(alpha: 0.8),
              child: Row(
                children: [
                  const SizedBox(width: 24, height: 24),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).qibla,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF111827),
                          ),
                    ),
                  ),
                  const SizedBox(width: 24, height: 24),
                ],
              ),
            ),
            // Compass + texts
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Consumer(
                  builder: (context, ref, _) {
                    final posAsync = ref.watch(positionProvider);

                    return posAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (e, _) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context).qiblaPermissionNeeded,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const LocationPermissionPage(),
                                    ),
                                  );
                                  // İzin verildiyse konumu yeniden dene.
                                  ref.invalidate(positionProvider);
                                },
                                child: Text(
                                  AppLocalizations.of(context).giveLocationPermission,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      data: (pos) {
                        final qiblaBearing = _calculateQiblaBearing(pos);

                        return Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: StreamBuilder<CompassEvent>(
                                    stream: FlutterCompass.events,
                                    builder: (context, snapshot) {
                                      final heading = snapshot.data?.heading;
                                      final headingDeg = heading ?? 0;
                                      final angleToQibla =
                                          (qiblaBearing - headingDeg) * pi / 180;

                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Outer circle
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isDark
                                                  ? const Color(0xFF1F2933)
                                                  : const Color(0xFFE5E7EB)
                                                      .withValues(alpha: 0.5),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(24),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isDark
                                                    ? const Color(0xFF4B5563)
                                                    : const Color(0xFFD1D5DB),
                                              ),
                                            ),
                                          ),
                                          // Cardinal directions (Turkish initials)
                                          Stack(
                                            children: [
                                              Align(
                                                alignment:
                                                    const Alignment(0, -0.9),
                                                child: Text(
                                                  AppLocalizations.of(context).northShort,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(0xFF14B866),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    const Alignment(0.9, 0),
                                                child: Text(
                                                  AppLocalizations.of(context).eastShort,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: isDark
                                                        ? const Color(0xFF9CA3AF)
                                                        : const Color(0xFF6B7280),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    const Alignment(0, 0.9),
                                                child: Text(
                                                  AppLocalizations.of(context).southShort,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: isDark
                                                        ? const Color(0xFF9CA3AF)
                                                        : const Color(0xFF6B7280),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    const Alignment(-0.9, 0),
                                                child: Text(
                                                  AppLocalizations.of(context).westShort,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: isDark
                                                        ? const Color(0xFF9CA3AF)
                                                        : const Color(0xFF6B7280),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Qibla indicator arrow / Kaaba icon
                                          Transform.rotate(
                                            angle: angleToQibla,
                                            child: Align(
                                              alignment:
                                                  const Alignment(0, -0.75),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 44,
                                                    height: 44,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFF14B866)
                                                          .withValues(alpha: 0.25),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons.mosque,
                                                      color:
                                                          Color(0xFF14B866),
                                                      size: 30,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Center degree text
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '${qiblaBearing.toStringAsFixed(0)}°',
                                                style: TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark
                                                      ? Colors.white
                                                      : const Color(0xFF111827),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                AppLocalizations.of(context).qiblaDirection,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: isDark
                                                      ? const Color(0xFF9CA3AF)
                                                      : const Color(0xFF6B7280),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              if (heading != null)
                                                Text(
                                                  '${AppLocalizations.of(context).deviceHeading}: ${headingDeg.toStringAsFixed(0)}°',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: isDark
                                                        ? const Color(0xFF9CA3AF)
                                                        : const Color(0xFF6B7280),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              AppLocalizations.of(context).keepDeviceFlat,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? const Color(0xFFE5E7EB)
                                    : const Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context).calibrateCompass,
                              style: TextStyle(
                                fontSize: 13,
                                color: const Color(0xFF14B866)
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            FilledButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const QiblaCalibrationPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.screen_rotation_alt),
                              label: Text(AppLocalizations.of(context).calibrate),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context).compassDirections,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QiblaCalibrationPage extends StatefulWidget {
  const QiblaCalibrationPage({super.key});

  @override
  State<QiblaCalibrationPage> createState() => _QiblaCalibrationPageState();
}

class _QiblaCalibrationPageState extends State<QiblaCalibrationPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).compassCalibration),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context).calibrationInstructions,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                      color: isDark
                          ? const Color(0xFFD1D5DB)
                          : const Color(0xFF4B5563),
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CustomPaint(
                      painter:
                          _FigureEightPainter(isDark: isDark),
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final t = _controller.value * 2 * pi;
                          final x = sin(t);
                          final y = sin(t * 2) / 1.2;
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final size = constraints.biggest;
                              final dx = size.width / 2 + x * size.width * 0.3;
                              final dy = size.height / 2 + y * size.height * 0.3;
                              return Stack(
                                children: [
                                  Positioned(
                                    left: dx - 24,
                                    top: dy - 24,
                                    child: child!,
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF14B866)
                                .withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.smartphone,
                            color: Color(0xFF14B866),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final l10n = AppLocalizations.of(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.calibrationCompleted),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context).completeCalibration),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FigureEightPainter extends CustomPainter {
  _FigureEightPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? const Color(0xFF374151)
          : const Color(0xFFCBD5F5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.25;

    path.addOval(Rect.fromCircle(
      center: center.translate(-radius * 0.8, 0),
      radius: radius,
    ));
    path.addOval(Rect.fromCircle(
      center: center.translate(radius * 0.8, 0),
      radius: radius,
    ));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FigureEightPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
