import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/models/period.dart';

void main() {
  group('Period', () {
    test('day starts at midnight and ends at next midnight', () {
      final period = Period(
        type: PeriodType.day,
        anchor: DateTime(2026, 11, 12, 15, 30),
      );
      expect(period.start, DateTime(2026, 11, 12));
      expect(period.end, DateTime(2026, 11, 13));
    });
    test('week starts from Monday', () {
      final period = Period(
        type: PeriodType.week,
        anchor: DateTime(2026, 11, 12),
      );
      expect(period.start, DateTime(2026, 11, 9));
      expect(period.end, DateTime(2026, 11, 16));
    });
    test('a week will cross the month', () {
      final period = Period(
        type: PeriodType.week,
        anchor: DateTime(2026, 12, 2),
      );
      expect(period.start, DateTime(2026, 11, 30));
      expect(period.end, DateTime(2026, 12, 7));
    });
    test('February check', () {
      final period = Period(
        type: PeriodType.month,
        anchor: DateTime(2026, 2, 15),
      );
      expect(period.start, DateTime(2026, 2, 1));
      expect(period.end, DateTime(2026, 3, 1));
    });
    test('year check', () {
      final period = Period(
        type: PeriodType.year,
        anchor: DateTime(2026, 6, 10),
      );
      expect(period.start, DateTime(2026, 1, 1));
      expect(period.end, DateTime(2027, 1, 1));
    });
    test('previous month will cross year', () {
      final period = Period(
        type: PeriodType.month,
        anchor: DateTime(2026, 1, 15),
      );
      final result = period.previous();
      expect(result.start, DateTime(2025, 12, 1));
    });
    test('next month will cross year', () {
      final period = Period(
        type: PeriodType.month,
        anchor: DateTime(2026, 12, 15),
      );
      final result = period.next();
      expect(result.start, DateTime(2027, 1, 1));
    });
    test('previous week will cross month', () {
      final period = Period(
        type: PeriodType.week,
        anchor: DateTime(2026, 12, 2),
      );
      final result = period.previous();
      expect(result.start, DateTime(2026, 11, 23));
    });
    test('previous day in a leap year', () {
      final period = Period(type: PeriodType.day, anchor: DateTime(2028, 3, 1));
      final result = period.previous();
      expect(result.start, DateTime(2028, 2, 29));
    });
    test('contains check', () {
      final period = Period(
        type: PeriodType.month,
        anchor: DateTime(2026, 11, 15),
      );
      expect(period.contains(DateTime(2026, 11, 1)), true);
      expect(period.contains(DateTime(2026, 11, 30, 23, 59)), true);
      expect(period.contains(DateTime(2026, 12, 1)), false);
      expect(period.contains(DateTime(2026, 10, 31, 23, 59)), false);
    });
    test('if its possible to go on next day/week/month/year', () {
      final current = Period.current(PeriodType.month);
      expect(current.canGoNext, false);
      expect(current.previous().canGoNext, true);
    });
    test('month label test', () {
      final period = Period(
        type: PeriodType.month,
        anchor: DateTime(2026, 11, 15),
      );
      expect(period.label, 'November 2026');
    });
    test('week label test', () {
      final period = Period(
        type: PeriodType.week,
        anchor: DateTime(2026, 11, 12),
      );
      expect(period.label, '9 Nov - 15 Nov');
    });
  });
}
