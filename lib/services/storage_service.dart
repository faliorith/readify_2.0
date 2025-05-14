import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _themeKey = 'app_theme';
  static const String _languageKey = 'app_language';
  static const String _userDataKey = 'user_data';
  static const String _recentSearchesKey = 'recent_searches';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Theme
  Future<void> setThemeMode(String theme) async {
    await _prefs.setString(_themeKey, theme);
  }

  String? getThemeMode() {
    return _prefs.getString(_themeKey);
  }

  // Language
  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
  }

  String getLanguage() {
    return _prefs.getString(_languageKey) ?? 'en';
  }

  // User Data
  Future<void> setUserData(Map<String, dynamic> userData) async {
    await _prefs.setString(_userDataKey, jsonEncode(userData));
  }

  Map<String, dynamic>? getUserData() {
    final data = _prefs.getString(_userDataKey);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  // Recent Searches
  Future<void> addRecentSearch(String query) async {
    final searches = getRecentSearches();
    if (!searches.contains(query)) {
      searches.insert(0, query);
      if (searches.length > 10) {
        searches.removeLast();
      }
      await _prefs.setStringList(_recentSearchesKey, searches);
    }
  }

  List<String> getRecentSearches() {
    return _prefs.getStringList(_recentSearchesKey) ?? [];
  }

  Future<void> clearRecentSearches() async {
    await _prefs.remove(_recentSearchesKey);
  }

  // Clear All Data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
} 