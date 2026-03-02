import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'location_permission_page.dart';

class StitchWelcomePage extends StatelessWidget {
  const StitchWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Premium Color Palette
    const bgTop = Color(0xFF051814);
    const bgBottom = Color(0xFF0F3D32);
    const accentGold = Color(0xFFD4AF37);
    const accentGreen = Color(0xFF19E680);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: bgBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 48),
                      // Hero Icon with Glow
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentGreen.withValues(alpha: 0.2),
                              blurRadius: 32,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mosque_outlined,
                          size: 80,
                          color: accentGreen,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Title
                      Text(
                        AppLocalizations.of(context).appName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context).welcome,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const SizedBox(height: 48),
                      // Features Grid
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.1,
                            children: [
                              _GlassCard(
                                icon: Icons.schedule_rounded,
                                title: AppLocalizations.of(
                                  context,
                                ).prayerTimesFeature,
                                accentColor: accentGold,
                              ),
                              _GlassCard(
                                icon: Icons.explore_rounded,
                                title: AppLocalizations.of(
                                  context,
                                ).qiblaCompass,
                                accentColor: accentGreen,
                              ),
                              _GlassCard(
                                icon: Icons.menu_book_rounded,
                                title: AppLocalizations.of(context).holyQuran,
                                accentColor: Colors.lightBlueAccent,
                              ),
                              _GlassCard(
                                icon: Icons.notifications_active_rounded,
                                title: AppLocalizations.of(context).reminders,
                                accentColor: Colors.orangeAccent,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom Action Area
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [bgBottom.withValues(alpha: 0.0), bgBottom],
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LocationPermissionPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentGreen,
                      foregroundColor: bgTop,
                      elevation: 8,
                      shadowColor: accentGreen.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context).letsStart.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color accentColor;

  const _GlassCard({
    required this.icon,
    required this.title,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
