import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_model.dart';

class ExpenseService {
  static const String _expensesKey = 'expenses';
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<List<Expense>> getExpenses() async {
    final jsonString = _preferences.getString(_expensesKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      // Split by our delimiter
      final List<String> jsonParts = jsonString.split('||');
      final List<Expense> expenses = [];

      for (final part in jsonParts) {
        if (part.trim().isEmpty) continue;
        
        try {
          // Parse the JSON string back to a map
          final Map<String, dynamic> jsonMap = json.decode(part);
          final expense = Expense.fromJson(jsonMap);
          expenses.add(expense);
        } catch (e) {
          print('Error parsing expense part: $e');
          continue;
        }
      }

      return expenses;
    } catch (e) {
      print('Error parsing expenses: $e');
      return [];
    }
  }

  static Future<void> saveExpenses(List<Expense> expenses) async {
    try {
      final List<String> jsonStrings = expenses.map((expense) {
        return json.encode(expense.toJson());
      }).toList();
      
      final jsonString = jsonStrings.join('||');
      await _preferences.setString(_expensesKey, jsonString);
    } catch (e) {
      print('Error saving expenses: $e');
    }
  }

  static Future<void> addExpense(Expense expense) async {
    final expenses = await getExpenses();
    expenses.add(expense);
    await saveExpenses(expenses);
  }

  static Future<void> updateExpense(Expense updatedExpense) async {
    final expenses = await getExpenses();
    final index = expenses.indexWhere((expense) => expense.id == updatedExpense.id);
    if (index != -1) {
      expenses[index] = updatedExpense;
      await saveExpenses(expenses);
    }
  }

  static Future<void> deleteExpense(String id) async {
    final expenses = await getExpenses();
    expenses.removeWhere((expense) => expense.id == id);
    await saveExpenses(expenses);
  }

  static Future<double> getTotalExpenses() async {
    final expenses = await getExpenses();
    double total = 0.0;
    for (final expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  static Future<Map<String, double>> getCategoryTotals() async {
    final expenses = await getExpenses();
    final Map<String, double> totals = {};
    
    for (final expense in expenses) {
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    
    return totals;
  }
}