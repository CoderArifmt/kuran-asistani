import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/notification_service.dart';
import 'location_permission_page.dart';

class PrivacyPermissionsPage extends StatefulWidget {
  const PrivacyPermissionsPage({super.key});

  @override
  State<PrivacyPermissionsPage> createState() => _PrivacyPermissionsPageState();
}

class _PrivacyPermissionsPageState extends State<PrivacyPermissionsPage> {
  bool _loadingLocation = false;
  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;

  bool _loadingNotifications = false;
  bool? _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _refreshLocationStatus();
  }

  bool get _hasLocationPermission =>
      _serviceEnabled &&
      (_permission == LocationPermission.always ||
          _permission == LocationPermission.whileInUse);

  String get _locationStatusLabel {
    if (!_serviceEnabled) return 'Konum servisi kapalı';
    switch (_permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return 'İzin verildi';
      case LocationPermission.denied:
        return 'İzin reddedildi';
      case LocationPermission.deniedForever:
        return 'İzin kalıcı olarak reddedildi';
      case LocationPermission.unableToDetermine:
        return 'Durum belirlenemedi';
    }
  }

  Future<void> _refreshLocationStatus() async {
    setState(() {
      _loadingLocation = true;
    });
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();
      if (!mounted) return;
      setState(() {
        _serviceEnabled = serviceEnabled;
        _permission = permission;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingLocation = false;
        });
      }
    }
  }

  Future<void> _manageLocationPermission() async {
    // Eğer henüz izin alınmamışsa, uygulama içi izin sayfasına yönlendir.
    if (!_hasLocationPermission && mounted) {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const LocationPermissionPage()));
      if (mounted) {
        await _refreshLocationStatus();
      }
      return;
    }

    // İzin verilmiş fakat kullanıcı ayarları kontrol etmek istiyorsa, sistem ayarlarını aç.
    await Geolocator.openAppSettings();
    await _refreshLocationStatus();
  }

  Future<void> _refreshNotificationStatus() async {
    setState(() {
      _loadingNotifications = true;
    });
    try {
      final notificationsEnabled = await NotificationService.instance
          .areNotificationsEnabled();
      if (!mounted) return;
      setState(() {
        _notificationsEnabled = notificationsEnabled;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingNotifications = false;
        });
      }
    }
  }

  String get _notificationStatusLabel {
    if (_notificationsEnabled == null) {
      return 'Durum belirlenemedi';
    }
    return _notificationsEnabled!
        ? 'İzin verildi'
        : 'İzin reddedildi veya kapalı';
  }

  Future<void> _manageNotificationPermission() async {
    await NotificationService.instance.requestPermission();
    await _refreshNotificationStatus();
    // Android'de kullanıcıya ayarları da açma imkanı verelim.
    await NotificationService.instance.openNotificationSettings();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Bildirim izin durumunu ekran açıldığında da kontrol et
    // (konumla birlikte çağrılmasını istiyorsan initState içinde de çağrılabilir).
    if (_notificationsEnabled == null && !_loadingNotifications) {
      // Bu küçük hile, build içinde bir kere tetiklenmesini sağlar.
      // ignore: discarded_futures
      _refreshNotificationStatus();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Gizlilik ve izinler')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PrivacyCard(
            title: 'Konum izni',
            icon: Icons.location_on_rounded,
            description:
                'Bulunduğun şehre göre namaz vakitlerini hesaplamak için konum bilgisini kullanırız. Konum verilerin cihazından dışarı çıkmaz.',
            status: _loadingLocation
                ? 'Kontrol ediliyor...'
                : _locationStatusLabel,
            statusColor: _hasLocationPermission
                ? const Color(0xFF22C55E)
                : (isDark ? const Color(0xFFF97373) : const Color(0xFFDC2626)),
            actionLabel: _hasLocationPermission
                ? 'Sistem ayarlarını aç'
                : 'İzinleri yönet',
            onActionPressed: _loadingLocation
                ? null
                : _manageLocationPermission,
          ),
          const SizedBox(height: 16),
          _PrivacyCard(
            title: 'Bildirimler',
            icon: Icons.notifications_active,
            description:
                'Namaz vakti hatırlatmaları ve diğer bildirimler için cihazının bildirim sistemini kullanırız.',
            status: _loadingNotifications
                ? 'Kontrol ediliyor...'
                : _notificationStatusLabel,
            statusColor: (_notificationsEnabled ?? false)
                ? const Color(0xFF22C55E)
                : (isDark ? const Color(0xFFE5E7EB) : const Color(0xFF4B5563)),
            actionLabel: 'Bildirim izinlerini yönet',
            onActionPressed: _loadingNotifications
                ? null
                : _manageNotificationPermission,
          ),
          const SizedBox(height: 16),
          _PrivacyCard(
            title: 'Veri ve gizlilik',
            icon: Icons.lock_outline,
            description:
                'Uygulama içinde hesap oluşturma veya bulut senkronizasyonu yapılmaz. Veriler cihazında saklanır.',
            status: 'Kişisel veriler saklanmaz',
            statusColor: isDark
                ? const Color(0xFFE5E7EB)
                : const Color(0xFF4B5563),
          ),
        ],
      ),
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.status,
    required this.statusColor,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final IconData icon;
  final String description;
  final String status;
  final Color statusColor;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    const SizedBox(height: 2),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              height: 1.4,
              color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF4B5563),
            ),
          ),
          if (actionLabel != null && onActionPressed != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onActionPressed,
                child: Text(actionLabel!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
