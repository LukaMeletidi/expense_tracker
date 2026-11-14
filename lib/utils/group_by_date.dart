import 'package:expense_tracker/models/expense.dart';

Map<DateTime, List<Expense>> groupByDate(List<Expense> expenses) {
  final groups = <DateTime, List<Expense>>{};
  for (final expense in expenses) {
    final day = DateTime(
      expense.date.year,
      expense.date.month,
      expense.date.day,
    );
    groups.putIfAbsent(day, () => []).add(expense);
  }
  return groups;
}
