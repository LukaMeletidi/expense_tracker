import 'dart:async';

import 'package:expense_tracker/database/expenses_database.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesNotifier extends AsyncNotifier<List<Expense>> {
  @override
  FutureOr<List<Expense>> build() async {
    return ExpensesDatabase.getExpenses();
  }

  Future<void> addExpense(Expense expense) async {
    final savedExpense = await ExpensesDatabase.insertExpense(expense);
    final current = state.value ?? [];
    final savedList = [...current, savedExpense];
    savedList.sort((a, b) => b.date.compareTo(a.date));
    state = AsyncData(savedList);
  }

  Future<void> removeExpense(int id) async {
    final current = state.value ?? [];
    final finalList = current.where((expense) => expense.id != id).toList();
    state = AsyncData(finalList);
    await ExpensesDatabase.deleteExpense(id);
  }

  Future<void> updateExpense(Expense expense) async {
    await ExpensesDatabase.updateExpense(expense);
    final current = state.value ?? [];
    final updatedList =
        current.map((e) => e.id == expense.id ? expense : e).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    state = AsyncData(updatedList);
  }
}

final expensesProvider = AsyncNotifierProvider<ExpensesNotifier, List<Expense>>(
  ExpensesNotifier.new,
);
