import 'package:intl/intl.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String description;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.description = '',
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      category: json['category'],
      description: json['description'] ?? '',
    );
  }

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    String? category,
    String? description,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }

  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String get formattedAmount {
    return '\$${amount.toStringAsFixed(2)}';
  }

  static List<String> get categories => [
    'Food',
    'Transportation',
    'Entertainment',
    'Shopping',
    'Utilities',
    'Healthcare',
    'Education',
    'Other',
  ];

  static String getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return '🍕';
      case 'Transportation':
        return '🚗';
      case 'Entertainment':
        return '🎬';
      case 'Shopping':
        return '🛍️';
      case 'Utilities':
        return '🏠';
      case 'Healthcare':
        return '🏥';
      case 'Education':
        return '📚';
      default:
        return '💼';
    }
  }
}