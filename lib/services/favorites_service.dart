import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _duaKey = 'favorite_dua_ids_v1';
  static const _surahKey = 'favorite_surah_ids_v1';

  Future<Set<String>> getFavoriteDuaIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_duaKey) ?? const [];
    return list.toSet();
  }

  Future<Set<String>> toggleFavoriteDua(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final current = (prefs.getStringList(_duaKey) ?? const []).toSet();
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    await prefs.setStringList(_duaKey, current.toList());
    return current;
  }

  Future<Set<int>> getFavoriteSurahNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_surahKey) ?? const [];
    return list.map(int.parse).toSet();
  }

  Future<Set<int>> toggleFavoriteSurah(int number) async {
    final prefs = await SharedPreferences.getInstance();
    final current =
        (prefs.getStringList(_surahKey) ?? const []).map(int.parse).toSet();
    if (current.contains(number)) {
      current.remove(number);
    } else {
      current.add(number);
    }
    await prefs.setStringList(
      _surahKey,
      current.map((e) => e.toString()).toList(),
    );
    return current;
  }
}
