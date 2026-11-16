import 'package:expense_tracker/models/expense.dart';

Map<int, int> sumByCategory(List<Expense> expenses) {
  final totals = <int, int>{};
  for (final expense in expenses) {
    totals[expense.categoryId] =
        (totals[expense.categoryId] ?? 0) + expense.amountCents;
  }
  return totals;
}
