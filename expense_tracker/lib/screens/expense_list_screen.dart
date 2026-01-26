import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../services/expense_service.dart';
import '../widgets/expense_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/category_chip.dart';
import 'add_edit_expense_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<Expense> _expenses = [];
  double _totalAmount = 0.0;
  String? _selectedCategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() => _isLoading = true);
    final expenses = await ExpenseService.getExpenses();
    final total = await ExpenseService.getTotalExpenses();
    setState(() {
      _expenses = expenses;
      _totalAmount = total;
      _isLoading = false;
    });
  }

  List<Expense> get _filteredExpenses {
    if (_selectedCategory == null) return _expenses;
    return _expenses
        .where((expense) => expense.category == _selectedCategory)
        .toList();
  }

  void _addExpense() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditExpenseScreen(),
      ),
    );

    if (result == true) {
      await _loadExpenses();
    }
  }

  void _editExpense(Expense expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditExpenseScreen(expense: expense),
      ),
    );

    if (result == true) {
      await _loadExpenses();
    }
  }

  Future<void> _deleteExpense(String id) async {
    await ExpenseService.deleteExpense(id);
    await _loadExpenses();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            // In a real app, you would implement undo logic
            await _loadExpenses();
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteExpense(id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addExpense,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Total amount card
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Total Expenses',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${_totalAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        // Category filter chips
                        SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              CategoryChip(
                                category: 'All',
                                emoji: '📊',
                                isSelected: _selectedCategory == null,
                                onTap: () {
                                  setState(() => _selectedCategory = null);
                                },
                              ),
                              ...Expense.categories.map((category) {
                                return CategoryChip(
                                  category: category,
                                  emoji: Expense.getCategoryIcon(category),
                                  isSelected: _selectedCategory == category,
                                  onTap: () {
                                    setState(() => _selectedCategory = category);
                                  },
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Expense list
                Expanded(
                  child: _filteredExpenses.isEmpty
                      ? EmptyState(
                          message: _selectedCategory == null
                              ? 'No expenses yet.\nTap + to add your first expense!'
                              : 'No expenses in ${_selectedCategory} category',
                          icon: Icons.money_off,
                        )
                      : RefreshIndicator(
                          onRefresh: _loadExpenses,
                          child: ListView.builder(
                            itemCount: _filteredExpenses.length,
                            itemBuilder: (context, index) {
                              final expense = _filteredExpenses[index];
                              return Dismissible(
                                key: Key(expense.id),
                                background: Container(
                                  color: Theme.of(context).colorScheme.error,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                secondaryBackground: Container(
                                  color: Theme.of(context).colorScheme.error,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Expense'),
                                      content: const Text(
                                          'Are you sure you want to delete this expense?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                onDismissed: (direction) {
                                  _deleteExpense(expense.id);
                                },
                                child: ExpenseCard(
                                  expense: expense,
                                  onTap: () => _editExpense(expense),
                                  onDelete: () => _showDeleteDialog(expense.id),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}