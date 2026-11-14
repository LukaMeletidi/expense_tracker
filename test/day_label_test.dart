import 'package:expense_tracker/utils/day_label.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dayLabel', () {
    final now = DateTime(2026, 11, 13, 15, 30);
    test('today', () {
      expect(dayLabel(DateTime(2026, 11, 13), now), 'Today');
    });
    test('yesterday', () {
      expect(dayLabel(DateTime(2026, 11, 12), now), 'Yesterday');
    });
    test('yesterday across month boundary', () {
      expect(
        dayLabel(DateTime(2026, 10, 31), DateTime(2026, 11, 1)),
        'Yesterday',
      );
    });
    test('older date in the same year', () {
      expect(dayLabel(DateTime(2026, 11, 9), now), 'Monday, 9 Nov');
    });
    test('date from another year shows the year', () {
      expect(dayLabel(DateTime(2025, 3, 5), now), 'Wednesday, 5 Mar 2025');
    });
  });
}
