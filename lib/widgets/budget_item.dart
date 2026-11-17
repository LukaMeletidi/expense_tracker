import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/models/budget.dart';
import 'package:expense_tracker/models/budget_progress.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/providers/currency_provider.dart';
import 'package:expense_tracker/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetItem extends ConsumerWidget {
  const BudgetItem({
    super.key,
    required this.category,
    required this.budget,
    required this.spentCents,
    required this.onTap,
  });

  final Category category;
  final Budget budget;
  final int spentCents;
  final void Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final symbol = ref.watch(currencySymbolProvider);
    final progress = BudgetProgress(
      spentCents: spentCents,
      limitCents: budget.limitCents,
    );
    final scheme = Theme.of(context).colorScheme;
    final color = progress.isOver ? scheme.error : category.color;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(category.icon, color: category.color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    l10n.budgetSpentOf(
                      formatCents(spentCents, symbol),
                      formatCents(budget.limitCents, symbol),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress.barValue,
                color: color,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                progress.isOver
                    ? l10n.budgetOver(
                        formatCents(-progress.remainingCents, symbol),
                      )
                    : l10n.budgetLeft(
                        formatCents(progress.remainingCents, symbol),
                      ),
                style: TextStyle(color: progress.isOver ? scheme.error : null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
