import 'package:expense_tracker/utils/category_icons.dart';
import 'package:expense_tracker/utils/default_categories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('defaultCategories', () {
    test('has 11 categories', () {
      expect(defaultCategories.length, 11);
    });
    test('icon keys are unique', () {
      final keys = defaultCategories.map((c) => c.iconKey).toSet();
      expect(keys.length, defaultCategories.length);
    });
    test('every icon key exists in teh icon registry', () {
      for (final category in defaultCategories) {
        expect(categoryIcons.containsKey(category.iconKey), true);
      }
    });
  });
}
