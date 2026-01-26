import 'package:flutter/material.dart';
import '../models/bmi_record.dart';
import '../services/storage_service.dart';
import '../widgets/bmi_card.dart';
import '../widgets/input_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<BmiRecord> _records = [];
  double _height = 170;
  double _weight = 70;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final records = await _storageService.loadRecords();
    setState(() {
      _records = records;
    });
  }

  Future<void> _calculateAndSave() async {
    final record = BmiRecord.calculate(
      heightCm: _height,
      weightKg: _weight,
    );
    
    await _storageService.saveRecord(record);
    await _loadRecords();
    
    _showResultDialog(record);
  }

  void _showResultDialog(BmiRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('BMI Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${record.bmi}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: _getBmiColor(record.bmi),
              ),
            ),
            SizedBox(height: 8),
            Text(
              record.category,
              style: TextStyle(
                color: _getBmiColor(record.bmi),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Height: ${record.height.toStringAsFixed(0)} cm\n'
              'Weight: ${record.weight.toStringAsFixed(1)} kg',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  Future<void> _deleteRecord(int index) async {
    await _storageService.deleteRecord(index);
    await _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        actions: [
          if (_records.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () async {
                await _storageService.clearAllRecords();
                await _loadRecords();
              },
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Input Section
            InputSection(
              height: _height,
              weight: _weight,
              onHeightChanged: (value) => setState(() => _height = value),
              onWeightChanged: (value) => setState(() => _weight = value),
              onCalculate: _calculateAndSave,
            ),
            SizedBox(height: 24),
            // History Section
            Expanded(
              child: _records.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_toggle_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No BMI records yet',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Calculate your first BMI!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _records.length,
                      itemBuilder: (context, index) {
                        final record = _records[index];
                        return BmiCard(
                          record: record,
                          onDelete: () => _deleteRecord(index),
                          isDarkMode: isDarkMode,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}