import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/categories_provider.dart';
import 'package:expense_tracker/providers/currency_provider.dart';
import 'package:expense_tracker/providers/period_provider.dart';
import 'package:expense_tracker/screens/category_form_screen.dart';
import 'package:expense_tracker/utils/category_name.dart';
import 'package:expense_tracker/utils/format.dart';
import 'package:expense_tracker/utils/group_by_date.dart';
import 'package:expense_tracker/widgets/day_header.dart';
import 'package:expense_tracker/widgets/dismissible_expense.dart';
import 'package:expense_tracker/widgets/period_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryDetailScreen extends ConsumerWidget {
  const CategoryDetailScreen({super.key, required this.categoryId});

  final int categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final symbol = ref.watch(currencySymbolProvider);
    final category = ref.watch(categoriesByIdProvider)[categoryId];
    if (category == null) return const Scaffold();
    final expensesAsync = ref.watch(categoryExpensesProvider(categoryId));
    final total = ref.watch(categoryTotalsProvider)[categoryId] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName(category, l10n)),
        actions: [
          IconButton(
            onPressed: () async {
              final updated = await Navigator.push<Category>(
                context,
                MaterialPageRoute(
                  builder: (ctx) => CategoryFormScreen(category: category),
                ),
              );
              if (!context.mounted || updated == null) return;
              ref.read(categoriesProvider.notifier).updateCategory(updated);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: expensesAsync.when(
        error: (error, stack) =>
            Center(child: Text(l10n.errorMessage('$error'))),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (expenses) {
          final items = flattenByDate(expenses);
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: items.length + 1,
            itemBuilder: (ctx, index) {
              if (index == 0) {
                return Column(
                  children: [
                    const PeriodSelector(),
                    const SizedBox(height: 8),
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: category.color.withAlpha(40),
                      child: Icon(
                        category.icon,
                        size: 28,
                        color: category.color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formatCents(total, symbol),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: category.color,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(l10n.noExpensesInPeriod),
                      ),
                  ],
                );
              }
              final item = items[index - 1];
              if (item is DateTime) return DayHeader(day: item);
              final expense = item as Expense;
              return DismissibleExpense(
                key: ValueKey(expense.id),
                expense: expense,
              );
            },
          );
        },
      ),
    );
  }
}
