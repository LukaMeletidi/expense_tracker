import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/models/budget.dart';
import 'package:expense_tracker/models/period.dart';
import 'package:expense_tracker/providers/budgets_provider.dart';
import 'package:expense_tracker/providers/categories_provider.dart';
import 'package:expense_tracker/screens/budget_form_screen.dart';
import 'package:expense_tracker/widgets/budget_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
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
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No budgets yet.\nTap + to set a monthly limit for a category',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: visible.length + 1,
            itemBuilder: (ctx, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    Period.current(PeriodType.month).label(l10n.localeName),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                );
              }
              final budget = visible[index - 1];
              final category = categoriesById[budget.categoryId]!;
              final spentCents = spent[budget.categoryId] ?? 0;
              return Dismissible(
                key: ValueKey(budget.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
                onDismissed: (direction) {
                  final notifier = ref.read(budgetsProvider.notifier);
                  final messenger = ScaffoldMessenger.of(context);
                  notifier.removeBudget(budget.id!);
                  messenger.clearSnackBars();
                  messenger.showSnackBar(
                    SnackBar(
                      content: const Text('Budget deleted'),
                      persist: false,
                      duration: const Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () => notifier.addBudget(budget),
                      ),
                    ),
                  );
                },
                child: BudgetItem(
                  category: category,
                  budget: budget,
                  spentCents: spentCents,
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
                ),
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
