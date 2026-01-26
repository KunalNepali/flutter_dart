import 'dart:convert';

class BmiRecord {
  final DateTime date;
  final double height; // in cm
  final double weight; // in kg
  final double bmi;
  final String category;

  BmiRecord({
    required this.date,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'height': height,
    'weight': weight,
    'bmi': bmi,
    'category': category,
  };

  factory BmiRecord.fromJson(Map<String, dynamic> json) => BmiRecord(
    date: DateTime.parse(json['date']),
    height: json['height'],
    weight: json['weight'],
    bmi: json['bmi'],
    category: json['category'],
  );

  // Calculate BMI
  static BmiRecord calculate({
    required double heightCm,
    required double weightKg,
  }) {
    final heightM = heightCm / 100;
    final bmi = weightKg / (heightM * heightM);
    
    String category;
    if (bmi < 18.5) {
      category = 'Underweight';
    } else if (bmi < 25) {
      category = 'Normal';
    } else if (bmi < 30) {
      category = 'Overweight';
    } else {
      category = 'Obese';
    }

    return BmiRecord(
      date: DateTime.now(),
      height: heightCm,
      weight: weightKg,
      bmi: double.parse(bmi.toStringAsFixed(1)),
      category: category,
    );
  }
}