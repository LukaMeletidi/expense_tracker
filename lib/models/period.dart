import 'package:intl/intl.dart';

enum PeriodType {
  day('Day'),
  week('Week'),
  month('Month'),
  year('Year');

  const PeriodType(this.label);

  final String label;
}

class Period {
  const Period({required this.type, required this.anchor});

  final PeriodType type;
  final DateTime anchor;

  factory Period.current(PeriodType type) {
    final now = DateTime.now();
    return Period(type: type, anchor: DateTime(now.year, now.month, now.day));
  }

  DateTime get start => switch (type) {
    PeriodType.day => DateTime(anchor.year, anchor.month, anchor.day),
    PeriodType.week => DateTime(
      anchor.year,
      anchor.month,
      anchor.day - (anchor.weekday - 1),
    ),
    PeriodType.month => DateTime(anchor.year, anchor.month),
    PeriodType.year => DateTime(anchor.year),
  };

  DateTime get end {
    final s = start;
    return switch (type) {
      PeriodType.day => DateTime(s.year, s.month, s.day + 1),
      PeriodType.week => DateTime(s.year, s.month, s.day + 7),
      PeriodType.month => DateTime(s.year, s.month + 1),
      PeriodType.year => DateTime(s.year + 1),
    };
  }

  Period previous() {
    final s = start;
    return Period(type: type, anchor: DateTime(s.year, s.month, s.day - 1));
  }

  Period next() => Period(type: type, anchor: end);
  bool get canGoNext => !end.isAfter(DateTime.now());
  bool contains(DateTime date) => !date.isBefore(start) && date.isBefore(end);

  String get label {
    final s = start;
    return switch (type) {
      PeriodType.day => DateFormat('d MMM yyyy').format(s),
      PeriodType.week =>
        '${DateFormat('d MMM').format(s)} - ${DateFormat('d MMM').format(DateTime(s.year, s.month, s.day + 6))}',
      PeriodType.month => DateFormat('MMMM yyyy').format(s),
      PeriodType.year => '${s.year}',
    };
  }
}
