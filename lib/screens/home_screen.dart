import 'package:expense_tracker/database/expenses_database.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];

  Future<void> _loadExpenses() async {
    final list = await ExpensesDatabase.getExpenses();
    if (!mounted) return;
    setState(() {
      _expenses = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: _expenses.isEmpty
          ? const Center(child: Text('No expenses yet, tap + to add one'))
          : ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (ctx, index) =>
                  ExpenseItem(expense: _expenses[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.push<Expense>(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
          if (!mounted || newExpense == null) return;
          await ExpensesDatabase.insertExpense(newExpense);
          if (!mounted) return;
          await _loadExpenses();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
