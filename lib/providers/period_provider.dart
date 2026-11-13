import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/period.dart';
import 'package:expense_tracker/providers/expenses_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeriodNotifier extends Notifier<Period> {
  @override
  Period build() {
    return Period.current(PeriodType.month);
  }

  void setType(PeriodType type) {
    state = Period.current(type);
  }

  void previous() {
    state = state.previous();
  }

  void next() {
    if (state.canGoNext) {
      state = state.next();
    }
  }
}

final periodProvider = NotifierProvider<PeriodNotifier, Period>(
  PeriodNotifier.new,
);

final periodExpensesProvider = Provider<AsyncValue<List<Expense>>>((ref) {
  final expensesAsync = ref.watch(expensesProvider);
  final period = ref.watch(periodProvider);
  return expensesAsync.whenData((expenses) {
    return expenses.where((expense) => period.contains(expense.date)).toList();
  });
});

final periodTotalProvider = Provider<int>((ref) {
  final expenses = ref.watch(periodExpensesProvider).value ?? [];
  return expenses.fold(0, (sum, expense) => sum + expense.amountCents);
});

final categoryTotalsProvider = Provider<Map<ExpenseCategory, int>>((ref) {
  final expenses = ref.watch(periodExpensesProvider).value ?? [];
  final totals = <ExpenseCategory, int>{};
  for (final expense in expenses) {
    totals[expense.category] =
        (totals[expense.category] ?? 0) + expense.amountCents;
  }
  return totals;
});