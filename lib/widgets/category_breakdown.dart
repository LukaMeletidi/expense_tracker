import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/providers/categories_provider.dart';
import 'package:expense_tracker/providers/currency_provider.dart';
import 'package:expense_tracker/providers/period_provider.dart';
import 'package:expense_tracker/utils/format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryBreakdown extends ConsumerWidget {
  const CategoryBreakdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final symbol = ref.watch(currencySymbolProvider);
    final totals = ref.watch(categoryTotalsProvider);
    final total = ref.watch(periodTotalProvider);
    final categories = ref.watch(categoriesByIdProvider);
    final unknown = Category(
      name: l10n.unknownCategory,
      iconKey: 'other',
      colorValue: 0xFF9E9E9E,
    );
    Category categoryOf(int id) => categories[id] ?? unknown;
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return entries.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(l10n.noExpensesInPeriod, textAlign: TextAlign.center),
            ),
          )
        : Column(
            children: [
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    PieChart(
                      PieChartData(
                        sections: entries
                            .map(
                              (e) => PieChartSectionData(
                                value: e.value.toDouble(),
                                color: categoryOf(e.key).color,
                                title: '${(e.value / total * 100).round()} %',
                                radius: 40,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Center(
                      child: Text(
                        formatCents(total, symbol),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
              ...entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            categoryOf(entry.key).icon,
                            color: categoryOf(entry.key).color,
                          ),
                          const SizedBox(width: 20),
                          Expanded(child: Text(categoryOf(entry.key).name)),
                          const SizedBox(width: 20),
                          Text(formatCents(entry.value, symbol)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        color: categoryOf(entry.key).color,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                        value: entry.value / total,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
