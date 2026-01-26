import 'package:flutter/material.dart';
import '../models/bmi_record.dart';

class BmiCard extends StatelessWidget {
  final BmiRecord record;
  final VoidCallback onDelete;
  final bool isDarkMode;

  const BmiCard({
    required this.record,
    required this.onDelete,
    required this.isDarkMode,
  });

  Color _getBmiColor() {
    if (record.bmi < 18.5) return Colors.blue;
    if (record.bmi < 25) return Colors.green;
    if (record.bmi < 30) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Dismissible(
        key: Key(record.date.toIso8601String()),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) => onDelete(),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getBmiColor().withOpacity(0.2),
            child: Text(
              record.bmi.toString(),
              style: TextStyle(
                color: _getBmiColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            '${record.height.toStringAsFixed(0)} cm | ${record.weight.toStringAsFixed(1)} kg',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            record.category,
            style: TextStyle(color: _getBmiColor()),
          ),
          trailing: Text(
            DateFormat('MMM d, yyyy').format(record.date),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}