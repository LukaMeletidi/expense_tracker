import 'package:expense_tracker/models/budget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Budget', () {
    test('toMap and fromMap round trip', () {
      const budget = Budget(id: 1, categoryId: 3, limitCents: 10000);
      final restored = Budget.fromMap(budget.toMap());
      expect(restored.id, 1);
      expect(restored.categoryId, 3);
      expect(restored.limitCents, 10000);
    });
    test('copyWith changes only the given fields', () {
      const budget = Budget(id: 1, categoryId: 3, limitCents: 10000);
      final changed = budget.copywith(limitCents: 20000);
      expect(changed.limitCents, 20000);
      expect(changed.id, 1);
      expect(changed.categoryId, 3);
    });
  });
}
