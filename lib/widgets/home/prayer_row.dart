import 'package:flutter/material.dart';

enum PrayerRowState { past, current, future }

class PrayerRow extends StatelessWidget {
  const PrayerRow({
    super.key,
    required this.label,
    required this.time,
    required this.state,
  });

  final String label;
  final String time;
  final PrayerRowState state;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg = Colors.transparent;
    Color iconBg = Colors.transparent;
    Color iconColor = Colors.white;
    Color textColor = Colors.white;
    Color timeColor = Colors.white;
    double opacity = 1.0;
    BoxBorder? border;

    switch (state) {
      case PrayerRowState.past:
      case PrayerRowState.current:
        bg = isDark
            ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.5)
            : const Color(0xFFE5E7EB).withValues(alpha: 0.5);
        iconBg = isDark ? const Color(0xFF374151) : const Color(0xFFD1D5DB);
        iconColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
        textColor = isDark ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280);
        timeColor = textColor;
        opacity = 0.6;
        break;
      case PrayerRowState.future:
        bg = isDark
            ? const Color(0xFF14B866).withValues(alpha: 0.3)
            : const Color(0xFF14B866).withValues(alpha: 0.2);
        iconBg = const Color(0xFF14B866);
        iconColor = Colors.white;
        textColor = isDark ? Colors.white : const Color(0xFF111827);
        timeColor = textColor;
        border = Border.all(color: const Color(0xFF14B866), width: 2);
        break;
    }

    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: border,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_iconForLabel(label), size: 24, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: state == PrayerRowState.future
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: state == PrayerRowState.future
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: timeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForLabel(String label) {
    // Note: This logic might need adjustment if labels are localized.
    // Ideally, pass an icon or an enum instead of relying on string matching.
    // For now, checking against both English and Turkish to be safe, or just default icons.
    // Since we are moving to localization, it's better to rely on the position or pass the icon directly.
    // However, to keep it simple for this refactor, I'll use a heuristic or just default icons.
    // Actually, let's look at the original code. It was matching 'İmsak', 'Güneş' etc.
    // I will update this to be more robust or accept the icon as a parameter in a future step.
    // For now, let's keep the switch but make it broad.

    final l = label.toLowerCase();
    if (l.contains('imsak') || l.contains('fajr')) {
      return Icons.stars;
    }
    if (l.contains('güneş') || l.contains('sunrise')) {
      return Icons.wb_sunny;
    }
    if (l.contains('öğle') || l.contains('dhuhr')) {
      return Icons.wb_sunny_outlined;
    }
    if (l.contains('ikindi') || l.contains('asr')) {
      return Icons.format_align_left;
    }
    if (l.contains('akşam') || l.contains('maghrib')) {
      return Icons.nights_stay;
    }
    if (l.contains('yatsı') || l.contains('isha')) {
      return Icons.bedtime;
    }

    return Icons.access_time;
  }
}
