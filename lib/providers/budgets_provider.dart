import 'dart:async';

import 'package:expense_tracker/database/expenses_database.dart';
import 'package:expense_tracker/models/budget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetsNotifier extends AsyncNotifier<List<Budget>> {
  @override
  FutureOr<List<Budget>> build() {
    return ExpensesDatabase.getBudgets();
  }

  Future<void> addBudget(Budget budget) async {
    final saved = await ExpensesDatabase.insertBudget(budget);
    final current = state.value ?? [];
    state = AsyncData([...current, saved]);
  }

  Future<void> updateBudget(Budget budget) async {
    final current = state.value ?? [];
    state = AsyncData(
      current.map((b) => b.id == budget.id ? budget : b).toList(),
    );
  }

  Future<void> removeBudget(int id) async {
    final current = state.value ?? [];
    state = AsyncData(current.where((b) => b.id != id).toList());
    await ExpensesDatabase.deleteBudget(id);
  }
}

final budgetsProvider = AsyncNotifierProvider<BudgetsNotifier, List<Budget>>(
  BudgetsNotifier.new,
);
