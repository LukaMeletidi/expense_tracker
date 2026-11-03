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
  final List<Expense> _expenses = [
    Expense(
      title: 'groceries',
      amountCents: 1270,
      date: DateTime(2026, 11, 1),
      category: ExpenseCategory.food,
    ),
    Expense(
      title: 'book',
      amountCents: 1050,
      date: DateTime(2026, 10, 31),
      category: ExpenseCategory.education,
    ),
    Expense(
      title: 'visit to doctor',
      amountCents: 5000,
      date: DateTime(2026, 10, 29),
      category: ExpenseCategory.health,
    ),
    Expense(
      title: 'gym',
      amountCents: 3500,
      date: DateTime(2026, 10, 27),
      category: ExpenseCategory.sport,
    ),
    Expense(
      title: 'movie',
      amountCents: 2500,
      date: DateTime(2026, 10, 28),
      category: ExpenseCategory.entertainment,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (ctx, index) => ExpenseItem(expense: _expenses[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.push<Expense>(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
          if (!mounted || newExpense == null) return;
          setState(() {
            _expenses.add(newExpense);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
