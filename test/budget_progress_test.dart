import 'package:expense_tracker/models/budget_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BudgetProgress', () {
    test('ratio is spent divided by limit', () {
      const progress = BudgetProgress(spentCents: 50, limitCents: 200);
      expect(progress.ratio, 0.25);
    });
    test('remaining is limit minus spent', () {
      const progress = BudgetProgress(spentCents: 30, limitCents: 100);
      expect(progress.remainingCents, 70);
    });
    test('is not over when spent equals the limit', () {
      const progress = BudgetProgress(spentCents: 100, limitCents: 100);
      expect(progress.isOver, false);
    });
    test('is over when spent is above the limit', () {
      const progress = BudgetProgress(spentCents: 101, limitCents: 100);
      expect(progress.isOver, true);
      expect(progress.remainingCents, -1);
    });
    test('bar value never goes above 1', () {
      const progress = BudgetProgress(spentCents: 300, limitCents: 100);
      expect(progress.ratio, 3.0);
      expect(progress.barValue, 1.0);
    });
    test('zero limit gives zero ratio', () {
      const progress = BudgetProgress(spentCents: 50, limitCents: 0);
      expect(progress.ratio, 0);
    });
  });
}
