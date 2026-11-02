import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Expense> expenses = [
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
        itemCount: expenses.length,
        itemBuilder: (ctx, index) => ExpenseItem(expense: expenses[index]),
      ),
    );
  }
}
