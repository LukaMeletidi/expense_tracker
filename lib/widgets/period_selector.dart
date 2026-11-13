import 'package:expense_tracker/models/period.dart';
import 'package:expense_tracker/providers/period_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeriodSelector extends ConsumerWidget {
  const PeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(periodProvider);
    final notifier = ref.read(periodProvider.notifier);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SegmentedButton<PeriodType>(
            segments: PeriodType.values
                .map(
                  (type) => ButtonSegment(value: type, label: Text(type.label)),
                )
                .toList(),
            selected: {period.type},
            onSelectionChanged: (selection) =>
                notifier.setType(selection.first),
            showSelectedIcon: false,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: notifier.previous,
              icon: const Icon(Icons.chevron_left),
            ),
            Text(period.label, style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              onPressed: period.canGoNext ? notifier.next : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ],
    );
  }
}
