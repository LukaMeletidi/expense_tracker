import 'package:expense_tracker/utils/category_icons.dart';
import 'package:flutter/material.dart';

class Category {
  const Category({
    this.id,
    required this.name,
    required this.iconKey,
    required this.colorValue,
    this.isDeleted = false,
  });

  final int? id;
  final String name;
  final String iconKey;
  final int colorValue;
  final bool isDeleted;

  IconData get icon => iconFor(iconKey);
  Color get color => Color(colorValue);
  
  Category copyWith({
    int? id,
    String? name,
    String? iconKey,
    int? colorValue,
    bool? isDeleted,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconKey: iconKey ?? this.iconKey,
      colorValue: colorValue ?? this.colorValue,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'icon_key': iconKey,
    'color': colorValue,
    'is_deleted': isDeleted ? 1 : 0,
  };

  factory Category.fromMap(Map<String, Object?> map) => Category(
    id: map['id'] as int,
    name: map['name'] as String,
    iconKey: map['icon_key'] as String,
    colorValue: map['color'] as int,
    isDeleted: (map['is_deleted'] as int) == 1,
  );
}
