import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache service for storing and retrieving data with expiration
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  static CacheService get instance => _instance;

  SharedPreferences? _prefs;
  final Map<String, dynamic> _memoryCache = {};

  /// Initialize SharedPreferences
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Save data to cache with optional expiration (in hours)
  Future<bool> set(String key, dynamic value, {int? expirationHours}) async {
    await initialize();
    
    // Memory cache
    _memoryCache[key] = value;
    
    // Persistent cache with expiration
    final cacheData = {
      'value': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expirationHours': expirationHours,
    };
    
    return await _prefs!.setString(key, jsonEncode(cacheData));
  }

  /// Get data from cache (checks expiration)
  Future<T?> get<T>(String key) async {
    await initialize();
    
    // Check memory cache first
    if (_memoryCache.containsKey(key)) {
      return _memoryCache[key] as T?;
    }
    
    // Check persistent cache
    final data = _prefs!.getString(key);
    if (data == null) return null;
    
    try {
      final cacheData = jsonDecode(data);
      final timestamp = cacheData['timestamp'] as int;
      final expirationHours = cacheData['expirationHours'] as int?;
      
      // Check if expired
      if (expirationHours != null) {
        final expirationTime = DateTime.fromMillisecondsSinceEpoch(timestamp)
            .add(Duration(hours: expirationHours));
        
        if (DateTime.now().isAfter(expirationTime)) {
          await remove(key);
          return null;
        }
      }
      
      final value = cacheData['value'];
      _memoryCache[key] = value; // Cache in memory
      return value as T?;
    } catch (e) {
      return null;
    }
  }

  /// Remove from cache
  Future<bool> remove(String key) async {
    await initialize();
    _memoryCache.remove(key);
    return await _prefs!.remove(key);
  }

  /// Clear all cache
  Future<bool> clearAll() async {
    await initialize();
    _memoryCache.clear();
    return await _prefs!.clear();
  }

  /// Clear memory cache only (keeps persistent)
  void clearMemory() {
    _memoryCache.clear();
  }

  /// Get cache size (number of items)
  Future<int> getCacheSize() async {
    await initialize();
    return _prefs!.getKeys().length;
  }
}
