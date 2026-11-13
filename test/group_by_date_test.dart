import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/group_by_date.dart';
import 'package:flutter_test/flutter_test.dart';

Expense makeExpense(DateTime date) {
  return Expense(
    title: 'test',
    amountCents: 100,
    date: date,
    category: ExpenseCategory.food,
  );
}

void main() {
  group('groupByDate', () {
    test('empty list gives empty map', () {
      expect(groupByDate([]), isEmpty);
    });
    test('same day different hours go into one group', () {
      final result = groupByDate([
        makeExpense(DateTime(2026, 11, 13, 10, 0)),
        makeExpense(DateTime(2026, 11, 13, 18, 30)),
      ]);
      expect(result.length, 1);
      expect(result[DateTime(2026, 11, 13)]!.length, 2);
    });
    test('different days go into different groups', () {
      final result = groupByDate([
        makeExpense(DateTime(2026, 11, 13)),
        makeExpense(DateTime(2026, 11, 12)),
      ]);
      expect(result.length, 2);
    });
    test('keeps the order of the input', () {
      final result = groupByDate([
        makeExpense(DateTime(2026, 11, 13)),
        makeExpense(DateTime(2026, 11, 9)),
        makeExpense(DateTime(2026, 10, 30)),
      ]);
      expect(result.keys.toList(), [
        DateTime(2026, 11, 13),
        DateTime(2026, 11, 9),
        DateTime(2026, 10, 30),
      ]);
    });
  });
}
