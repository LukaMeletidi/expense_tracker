
import 'package:expense_tracker/utils/format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatCents', () {
    test('uses the dollar sign by default', () {
      expect(formatCents(12570), r'125.70 $');
    });
    test('uses the given symbol', () {
      expect(formatCents(12570, '₾'), '125.70 ₾');
    });
    test('shows zero with two decimals', () {
      expect(formatCents(0, '€'), '0.00 €');
    });
    test('pads small amounts', () {
      expect(formatCents(5, '€'), '0.05 €');
    });
  });
}