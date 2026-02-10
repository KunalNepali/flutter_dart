import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _categoriesKey = 'quiz_categories';
  static const String _resultsKey = 'quiz_results';
  static const String _progressKey = 'quiz_progress';

  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  // Save categories progress
  static Future<void> saveCategories(
    List<Map<String, dynamic>> categories,
  ) async {
    final prefs = await _prefs;
    await prefs.setString(_categoriesKey, json.encode(categories));
  }

  // Load categories progress
  static Future<List<Map<String, dynamic>>?> loadCategories() async {
    final prefs = await _prefs;
    final data = prefs.getString(_categoriesKey);
    if (data != null) {
      return List<Map<String, dynamic>>.from(json.decode(data));
    }
    return null;
  }

  // Save quiz results
  static Future<void> saveResult(Map<String, dynamic> result) async {
    final prefs = await _prefs;
    final results = await loadResults();
    results.add(result);
    await prefs.setString(_resultsKey, json.encode(results));
  }

  // Load all results
  static Future<List<Map<String, dynamic>>> loadResults() async {
    final prefs = await _prefs;
    final data = prefs.getString(_resultsKey);
    if (data != null) {
      return List<Map<String, dynamic>>.from(json.decode(data));
    }
    return [];
  }

  // Save question progress
  static Future<void> saveProgress(
    String categoryId,
    Map<String, dynamic> progress,
  ) async {
    final prefs = await _prefs;
    final key = '$_progressKey-$categoryId';
    await prefs.setString(key, json.encode(progress));
  }

  // Load question progress
  static Future<Map<String, dynamic>?> loadProgress(String categoryId) async {
    final prefs = await _prefs;
    final key = '$_progressKey-$categoryId';
    final data = prefs.getString(key);
    if (data != null) {
      return Map<String, dynamic>.from(json.decode(data));
    }
    return null;
  }

  // Clear all data
  static Future<void> clearAllData() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}
