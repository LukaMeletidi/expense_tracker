import 'dart:async';

import 'package:expense_tracker/database/expenses_database.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesNotifier extends AsyncNotifier<List<Category>> {
  @override
  FutureOr<List<Category>> build() => ExpensesDatabase.getCategories();

  Future<void> addCategory(Category category) async {
    final saved = await ExpensesDatabase.insertCategory(category);
    final current = state.value ?? [];
    state = AsyncData([...current, saved]);
  }

  Future<void> updateCategory(Category category) async {
    await ExpensesDatabase.updateCategory(category);
    final current = state.value ?? [];
    state = AsyncData(
      current.map((c) => c.id == category.id ? category : c).toList(),
    );
  }
}

final categoriesProvider =
    AsyncNotifierProvider<CategoriesNotifier, List<Category>>(
      CategoriesNotifier.new,
    );

final activeCategoriesProvider = Provider<AsyncValue<List<Category>>>((ref) {
  return ref
      .watch(categoriesProvider)
      .whenData((list) => list.where((c) => !c.isDeleted).toList());
});

final categoriesByProvider = Provider<Map<int, Category>>((ref) {
  final categories = ref.watch(categoriesProvider).value ?? [];
  return {for (final c in categories) c.id!: c};
});
