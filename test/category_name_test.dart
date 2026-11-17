import 'package:expense_tracker/l10n/app_localizations_en.dart';
import 'package:expense_tracker/l10n/app_localizations_ka.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/utils/category_name.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('categoryName', () {
    test('translates an original category', () {
      const category = Category(name: 'Food', iconKey: 'food', colorValue: 0);
      expect(categoryName(category, AppLocalizationsKa()), 'საკვები');
    });
    test('keeps the English name for English', () {
      const category = Category(name: 'Food', iconKey: 'food', colorValue: 0);
      expect(categoryName(category, AppLocalizationsEn()), 'Food');
    });
    test('does not translate a renamed category', () {
      const category = Category(
        name: 'Groceries',
        iconKey: 'food',
        colorValue: 0,
      );
      expect(categoryName(category, AppLocalizationsKa()), 'Groceries');
    });
    test('does not translate a custom category', () {
      const category = Category(name: 'Mancho', iconKey: 'gift', colorValue: 0);
      expect(categoryName(category, AppLocalizationsKa()), 'Mancho');
    });
    test('does not translate when only the name matches', () {
      const category = Category(name: 'Food', iconKey: 'gift', colorValue: 0);
      expect(categoryName(category, AppLocalizationsKa()), 'Food');
    });
  });
}
