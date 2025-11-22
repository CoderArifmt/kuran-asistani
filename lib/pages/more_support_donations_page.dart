import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreSupportDonationsPage extends StatelessWidget {
  const MoreSupportDonationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                          'Destek & Bağış',
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
                        'Uygulamayı destekle',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Namaz ve Kur\'an Asistanı gönüllü olarak geliştirilmekte. Uygulamayı beğendiysen değerlendirme bırakabilir, arkadaşlarınla paylaşabilir veya istersen bağışla destek olabilirsin.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                          color: isDark
                              ? const Color(0xFFD1D5DB)
                              : const Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SupportCard(
                        icon: Icons.star_rate,
                        title: 'Mağazada değerlendirme yap',
                        description:
                            'Uygulamayı beğendiysen, kısa bir değerlendirme diğer kullanıcılara da yardımcı olur.',
                        onTap: () async {
                          // Google Play'de genel bir arama aç (uygulama yayınlandığında paket adına göre güncelleyebilirsin).
                          final uri = Uri.parse(
                            'https://play.google.com/store/search?q=Namaz%20ve%20Kur%27an%20Asistan%C4%B1&c=apps',
                          );
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _SupportCard(
                        icon: Icons.share,
                        title: 'Arkadaşlarınla paylaş',
                        description:
                            'Ailen ve dostlarınla uygulamayı paylaşarak daha fazla kişiye ulaşmasına katkı sağlayabilirsin.',
                        onTap: () async {
                          // Uygulama linki hazır olduğunda buraya koyabilirsin.
                          const url =
                              'https://example.com/namaz-kuran-asistani';
                          final uri = Uri.parse(url);
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _SupportCard(
                        icon: Icons.volunteer_activism,
                        title: 'Bağış ile destek ol',
                        description:
                            'Maddi destek vermek istersen, ileride buraya güvenilir bağış bağlantıları eklenecek.',
                        onTap: () async {
                          // Şimdilik sadece bilgilendirme; ileride gerçek bağış adresi eklenebilir.
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Bağış bağlantıları henüz eklenmedi.',
                                ),
                              ),
                            );
                          }
                        },
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

class _SupportCard extends StatelessWidget {
  const _SupportCard({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF14B866).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF14B866)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 1.4,
                      color: isDark
                          ? const Color(0xFFD1D5DB)
                          : const Color(0xFF4B5563),
                    ),
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
