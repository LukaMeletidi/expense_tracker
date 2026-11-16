import 'dart:async';

import 'package:expense_tracker/database/expenses_database.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesNotifier extends AsyncNotifier<List<Category>> {
  @override
  FutureOr<List<Category>> build() => ExpensesDatabase.getCategories();
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
