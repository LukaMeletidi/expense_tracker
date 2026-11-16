import 'package:expense_tracker/utils/day_label.dart';
import 'package:flutter/material.dart';

class DayHeader extends StatelessWidget {
  const DayHeader({super.key, required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        dayLabel(day, DateTime.now()),
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
