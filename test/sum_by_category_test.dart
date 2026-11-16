import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/sum_by_category.dart';
import 'package:flutter_test/flutter_test.dart';

Expense expense(int categoryId, int cents) {
  return Expense(
    title: 't',
    amountCents: cents,
    date: DateTime(2026, 11, 13),
    categoryId: categoryId,
  );
}

void main() {
  group('sumByCategory', () {
    test('empty list gives an empty map', () {
      expect(sumByCategory([]), isEmpty);
    });
    test('sums the amounts of each category', () {
      final totals = sumByCategory([
        expense(1, 100),
        expense(1, 250),
        expense(2, 500),
      ]);
      expect(totals[1], 350);
      expect(totals[2], 500);
      expect(totals.length, 2);
    });
    test('does not include categories without expenses', () {
      final totals = sumByCategory([expense(1, 100)]);
      expect(totals.containsKey(3), false);
    });
  });
}
