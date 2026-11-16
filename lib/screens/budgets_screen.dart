import 'package:expense_tracker/models/budget.dart';
import 'package:expense_tracker/providers/budgets_provider.dart';
import 'package:expense_tracker/providers/categories_provider.dart';
import 'package:expense_tracker/screens/budget_form_screen.dart';
import 'package:expense_tracker/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetAsync = ref.watch(budgetsProvider);
    final categoriesById = ref.watch(categoriesByIdProvider);
    final spent = ref.watch(monthSpentProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: budgetAsync.when(
        error: (error, stack) => Center(child: Text('Error $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (budgets) {
          final visible = budgets
              .where((b) => categoriesById[b.categoryId]?.isDeleted == false)
              .toList();
          if (visible.isEmpty) {
            return const Center(child: Text('No budgets yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: visible.length,
            itemBuilder: (ctx, index) {
              final budget = visible[index];
              final category = categoriesById[budget.categoryId]!;
              final spentCents = spent[budget.categoryId] ?? 0;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: category.color.withAlpha(40),
                  child: Icon(category.icon, color: category.color),
                ),
                title: Text(category.name),
                subtitle: Text(
                  '${formatCents(spentCents)} of ${formatCents(budget.limitCents)}',
                ),
                onTap: () async {
                  final updated = await Navigator.push<Budget>(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => BudgetFormScreen(
                        categories: [category],
                        budget: budget,
                      ),
                    ),
                  );
                  if (!context.mounted || updated == null) return;
                  ref.read(budgetsProvider.notifier).updateBudget(updated);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final used = (ref.read(budgetsProvider).value ?? [])
              .map((b) => b.categoryId)
              .toSet();
          final available = (ref.read(activeCategoriesProvider).value ?? [])
              .where((c) => !used.contains(c.id))
              .toList();
          if (available.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('All categories already have a budget'),
                persist: false,
              ),
            );
            return;
          }
          final newBudget = await Navigator.push<Budget>(
            context,
            MaterialPageRoute(
              builder: (ctx) => BudgetFormScreen(categories: available),
            ),
          );
          if (!context.mounted || newBudget == null) return;
          ref.read(budgetsProvider.notifier).addBudget(newBudget);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
