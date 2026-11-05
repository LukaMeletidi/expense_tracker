import 'package:expense_tracker/providers/month_provider.dart';
import 'package:expense_tracker/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryBreakdown extends ConsumerWidget {
  const CategoryBreakdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totals = ref.watch(categoryTotalsProvider);
    final total = ref.watch(monthTotalProvider);
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return entries.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text(
                'No expenses this month',
                textAlign: TextAlign.center,
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(entry.key.icon),
                        const SizedBox(width: 20),
                        Expanded(child: Text(entry.key.label)),
                        const SizedBox(width: 20),
                        Text(formatCents(entry.value)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                      value: entry.value / total,
                    ),
                  ],
                ),
              );
            },
          );
  }
}
