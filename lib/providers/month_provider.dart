import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/expenses_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void previousMonth() {
    state = DateTime(state.year, state.month - 1);
  }

  void nextMonth() {
    final next = DateTime(state.year, state.month + 1);
    final now = DateTime.now();
    if (next.isAfter(now)) return;
    state = next;
  }
}

final selectedMonthProvider = NotifierProvider<SelectedMonthNotifier, DateTime>(
  SelectedMonthNotifier.new,
);

final monthExpensesProvider = Provider<AsyncValue<List<Expense>>>((ref) {
  final expensesAsync = ref.watch(expensesProvider);
  final month = ref.watch(selectedMonthProvider);

  return expensesAsync.whenData((expenses) {
    return expenses
        .where(
          (expense) =>
              expense.date.year == month.year &&
              expense.date.month == month.month,
        )
        .toList();
  });
});
