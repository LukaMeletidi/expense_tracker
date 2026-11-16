
import 'package:expense_tracker/models/expense.dart';

List<Expense> filterByTitle(List<Expense> expenses, String query) {
  final text = query.trim().toLowerCase();
  if (text.isEmpty) return expenses;
  return expenses.where((e) => e.title.toLowerCase().contains(text)).toList();
}