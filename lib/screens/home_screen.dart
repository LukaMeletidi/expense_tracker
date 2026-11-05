import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/expenses_provider.dart';
import 'package:expense_tracker/providers/month_provider.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:expense_tracker/widgets/month_selector.dart';
import 'package:expense_tracker/widgets/month_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(monthExpensesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: Column(
        children: [
          const MonthSelector(),
          const MonthSummary(),
          Expanded(
            child: expensesAsync.when(
              error: (error, stack) => Center(child: Text('Error $error')),
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (expenses) => expenses.isEmpty
                  ? const Center(child: Text('No expenses this month'))
                  : ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (ctx, index) => Dismissible(
                        key: ValueKey(expenses[index].id),
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
                            .removeExpense(expenses[index].id!),
                        child: ExpenseItem(
                          expense: expenses[index],
                          onTap: () async {
                            final updated = await Navigator.push<Expense>(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    AddExpenseScreen(expense: expenses[index]),
                              ),
                            );
                            if (!context.mounted || updated == null) return;
                            ref
                                .read(expensesProvider.notifier)
                                .updateExpense(updated);
                          },
                        ),
                      ),
                    ),
            ),
          ),
        ],
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
