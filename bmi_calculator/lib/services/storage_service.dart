import 'package:shared_preferences/shared_preferences.dart';
import '../models/bmi_record.dart';

class StorageService {
  static const String _recordsKey = 'bmi_records';

  Future<List<BmiRecord>> loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList(_recordsKey) ?? [];
    
    return recordsJson.map((json) {
      final data = jsonDecode(json) as Map<String, dynamic>;
      return BmiRecord.fromJson(data);
    }).toList();
  }

  Future<void> saveRecord(BmiRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await loadRecords();
    records.insert(0, record); // Add newest to top
    
    final recordsJson = records.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_recordsKey, recordsJson);
  }

  Future<void> deleteRecord(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await loadRecords();
    records.removeAt(index);
    
    final recordsJson = records.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_recordsKey, recordsJson);
  }

  Future<void> clearAllRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recordsKey);
  }
}