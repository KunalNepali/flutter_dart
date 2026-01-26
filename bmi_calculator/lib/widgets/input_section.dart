import 'package:flutter/material.dart';

class InputSection extends StatelessWidget {
  final double height;
  final double weight;
  final ValueChanged<double> onHeightChanged;
  final ValueChanged<double> onWeightChanged;
  final VoidCallback onCalculate;

  const InputSection({
    required this.height,
    required this.weight,
    required this.onHeightChanged,
    required this.onWeightChanged,
    required this.onCalculate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Calculate BMI',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            // Height Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Height (cm)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Slider(
                  value: height,
                  min: 100,
                  max: 250,
                  divisions: 150,
                  label: '${height.toStringAsFixed(0)} cm',
                  onChanged: onHeightChanged,
                ),
                Center(
                  child: Text(
                    '${height.toStringAsFixed(0)} cm',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Weight Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weight (kg)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Slider(
                  value: weight,
                  min: 20,
                  max: 200,
                  divisions: 180,
                  label: '${weight.toStringAsFixed(1)} kg',
                  onChanged: onWeightChanged,
                ),
                Center(
                  child: Text(
                    '${weight.toStringAsFixed(1)} kg',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Calculate Button
            FilledButton.icon(
              onPressed: onCalculate,
              icon: Icon(Icons.calculate),
              label: Text('Calculate BMI'),
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}