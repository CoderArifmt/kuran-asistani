import 'dart:ui';
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
    Color bg = Colors.transparent;
    Color iconBg = Colors.transparent;
    Color iconColor = Colors.white;
    Color textColor = Colors.white;
    Color timeColor = Colors.white;
    BoxBorder? border;

    switch (state) {
      case PrayerRowState.past:
      case PrayerRowState.current:
        bg = Colors.white.withValues(alpha: 0.05);
        iconBg = Colors.white.withValues(alpha: 0.1);
        iconColor = Colors.white.withValues(alpha: 0.4);
        textColor = Colors.white.withValues(alpha: 0.5);
        timeColor = textColor;
        break;
      case PrayerRowState.future:
        bg = Colors.white.withValues(alpha: 0.15);
        iconBg = const Color(0xFF34D399);
        iconColor = Colors.white;
        textColor = Colors.white;
        timeColor = const Color(0xFF34D399);
        border = Border.all(
          color: const Color(0xFF34D399).withValues(alpha: 0.5),
          width: 1.5,
        );
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: border,
        boxShadow: state == PrayerRowState.future
            ? [
                BoxShadow(
                  color: const Color(0xFF34D399).withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
              boxShadow: state == PrayerRowState.future
                  ? [
                      BoxShadow(
                        color: const Color(0xFF34D399).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Icon(_iconForLabel(label), size: 24, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: state == PrayerRowState.future
                    ? FontWeight.bold
                    : FontWeight.w600,
                color: textColor,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: timeColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
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
