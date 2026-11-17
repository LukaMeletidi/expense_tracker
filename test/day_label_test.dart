import 'package:intl/date_symbol_data_local.dart';
import 'package:expense_tracker/l10n/app_localizations_ka.dart';
import 'package:expense_tracker/l10n/app_localizations_en.dart';
import 'package:expense_tracker/utils/day_label.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('ka');
  });
  final l10n = AppLocalizationsEn();
  group('dayLabel', () {
    final now = DateTime(2026, 11, 13, 15, 30);
    test('today', () {
      expect(dayLabel(DateTime(2026, 11, 13), now, l10n), 'Today');
    });
    test('yesterday', () {
      expect(dayLabel(DateTime(2026, 11, 12), now, l10n), 'Yesterday');
    });
    test('yesterday across month boundary', () {
      expect(
        dayLabel(DateTime(2026, 10, 31), DateTime(2026, 11, 1), l10n),
        'Yesterday',
      );
    });
    test('older date in the same year', () {
      expect(dayLabel(DateTime(2026, 11, 9), now, l10n), 'Monday, 9 Nov');
    });
    test('date from another year shows the year', () {
      expect(
        dayLabel(DateTime(2025, 3, 5), now, l10n),
        'Wednesday, 5 Mar 2025',
      );
    });
    test('dayLabel uses Georgian text', () {
      final now = DateTime(2026, 11, 17);
      expect(dayLabel(now, now, AppLocalizationsKa()), 'დღეს');
    });
  });
}
