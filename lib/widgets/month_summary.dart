import 'package:expense_tracker/providers/period_provider.dart';
import 'package:expense_tracker/utils/format.dart';
import 'package:expense_tracker/widgets/category_breakdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthSummary extends ConsumerWidget {
  const MonthSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(periodTotalProvider);

    return Card(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            showDragHandle: true,
            builder: (ctx) => const CategoryBreakdown(),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total spent',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  formatCents(total),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
