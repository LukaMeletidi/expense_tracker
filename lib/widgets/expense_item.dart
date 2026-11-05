import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('d MMM y').format(expense.date);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(child: Icon(expense.category.icon)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(formattedDate),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Text(formatCents(expense.amountCents)),
          ],
        ),
      ),
    );
  }
}
