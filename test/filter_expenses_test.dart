import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/filter_expenses.dart';
import 'package:flutter_test/flutter_test.dart';

Expense expenseWithTitle(String title) {
  return Expense(
    title: title,
    amountCents: 100,
    date: DateTime(2026, 11, 13),
    categoryId: 1,
  );
}

void main() {
  group('filterByTitle', () {
    final expenses = [
      expenseWithTitle('Gym membership'),
      expenseWithTitle('food for dog'),
      expenseWithTitle('Coffee'),
    ];
    test('empty query returns everything', () {
      expect(filterByTitle(expenses, '').length, 3);
    });
    test('ignores upper and lower case', () {
      expect(filterByTitle(expenses, 'GYM').length, 1);
    });
    test('matches a part of the title', () {
      expect(filterByTitle(expenses, 'dog').first.title, 'food for dog');
    });

    test('trims spaces around the query', () {
      expect(filterByTitle(expenses, '  coffee ').length, 1);
    });
    test('returns an empty list when nothin matches', () {
      expect(filterByTitle(expenses, 'xyz'), isEmpty);
    });
  });
}
