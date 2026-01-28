import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:log_screen_ui/models/log_entry.dart';

abstract class LogRepository {
  Future<List<LogEntry>> getLogs();
  Future<void> addLog(LogEntry log);
  Future<void> clearLogs();
  Future<void> deleteLog(String id);
}

class LocalLogRepository implements LogRepository {
  static const String _storageKey = 'log_entries';
  final SharedPreferences _prefs;

  LocalLogRepository(this._prefs);

  @override
  Future<List<LogEntry>> getLogs() async {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => LogEntry.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addLog(LogEntry log) async {
    final logs = await getLogs();
    logs.add(log);
    await _saveLogs(logs);
  }

  @override
  Future<void> clearLogs() async {
    await _prefs.remove(_storageKey);
  }

  @override
  Future<void> deleteLog(String id) async {
    final logs = await getLogs();
    logs.removeWhere((log) => log.id == id);
    await _saveLogs(logs);
  }

  Future<void> _saveLogs(List<LogEntry> logs) async {
    final jsonList = logs.map((log) => log.toJson()).toList();
    await _prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}