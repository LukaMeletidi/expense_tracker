import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/utils/category_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Category', () {
    test('toMap and fromMap round trip', () {
      const category = Category(
        id: 1,
        name: 'Pets',
        iconKey: 'pets',
        colorValue: 0xFF795548,
      );
      final restored = Category.fromMap(category.toMap());
      expect(restored.id, 1);
      expect(restored.name, 'Pets');
      expect(restored.iconKey, 'pets');
      expect(restored.colorValue, 0xFF795548);
      expect(restored.isDeleted, false);
    });
    test('isDeleted is saved as 1', () {
      const category = Category(
        name: 'Old',
        iconKey: 'other',
        colorValue: 0xFF000000,
        isDeleted: true,
      );
      expect(category.toMap()['is_deleted'], 1);
    });
    test('iconFor returns the icon for a known key', () {
      expect(iconFor('food'), Icons.restaurant);
    });
    test('iconFor falls back for an unknown key', () {
      expect(iconFor('nonsense'), Icons.category);
    });
    test('copyWith changes only the given fields', () {
      const category = Category(
        id: 1,
        name: 'Pets',
        iconKey: 'pets',
        colorValue: 0xFF795548,
      );
      final changed = category.copyWith(name: 'Dogs');
      expect(changed.name, 'Dogs');
      expect(changed.id, 1);
      expect(changed.iconKey, 'pets');
      expect(changed.colorValue, 0xFF795548);
    });
    test('copyWith can mark a category as deleted', () {
      const category = Category(
        id: 1,
        name: 'Pets',
        iconKey: 'pets',
        colorValue: 0xFF795548,
      );
      expect(category.copyWith(isDeleted: true).isDeleted, true);
    });
  });
}
