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
      onDismissed: (direction) {
        final notifier = ref.read(expensesProvider.notifier);
        final messenger = ScaffoldMessenger.of(context);
        notifier.removeExpense(expense.id!);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: const Text('Expense deleted'),
            persist: false,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => notifier.addExpense(expense),
            ),
          ),
        );
      },
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
