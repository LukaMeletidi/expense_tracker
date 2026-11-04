import 'package:expense_tracker/providers/month_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MonthSelector extends ConsumerWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final now = DateTime.now();
    final isCurrentMonth = month.year == now.year && month.month == now.month;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () =>
              ref.read(selectedMonthProvider.notifier).previousMonth(),
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          DateFormat('MMM y').format(month),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          onPressed: isCurrentMonth
              ? null
              : () => ref.read(selectedMonthProvider.notifier).nextMonth(),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
