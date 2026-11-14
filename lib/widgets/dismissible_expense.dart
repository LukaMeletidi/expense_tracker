import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/expenses_provider.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DismissibleExpense extends ConsumerWidget {
  const DismissibleExpense({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
      ),
      confirmDismiss: (direction) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete expense?'),
          content: const Text('Are you sure you want to delete this expense?'),
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
      onDismissed: (direction) =>
          ref.read(expensesProvider.notifier).removeExpense(expense.id!),
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
  }
}
