import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/expenses_provider.dart';
import 'package:expense_tracker/providers/period_provider.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:expense_tracker/widgets/period_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/widgets/category_breakdown.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(periodExpensesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: expensesAsync.when(
        error: (error, stack) => Center(child: Text('Error $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (expenses) => ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: expenses.length + 1,
          itemBuilder: (ctx, index) {
            if (index == 0) {
              return const Column(
                children: [PeriodSelector(), CategoryBreakdown()],
              );
            }
            final expense = expenses[index - 1];
            return Dismissible(
              key: ValueKey(expense.id),
              direction: DismissDirection.endToStart,
              background: Container(
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              confirmDismiss: (direction) => showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete expense?'),
                  content: const Text(
                    'Are you sure you want to delete this expense?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx, false);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx, true);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ),
              onDismissed: (direction) => ref
                  .read(expensesProvider.notifier)
                  .removeExpense(expense.id!),
              child: ExpenseItem(
                expense: expense,
                onTap: () async {
                  final updated = await Navigator.push<Expense>(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => AddExpenseScreen(expense: expense),
                    ),
                  );
                  if (!context.mounted || updated == null) return;
                  ref.read(expensesProvider.notifier).updateExpense(updated);
                },
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.push<Expense>(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
          if (!context.mounted || newExpense == null) return;
          ref.read(expensesProvider.notifier).addExpense(newExpense);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
