import 'package:flutter/material.dart';

enum ExpenseCategory {
  food('Food', Icons.restaurant),
  transport('Transport', Icons.subway),
  shopping('Shopping', Icons.shopping_cart),
  health('Health', Icons.health_and_safety),
  sport('Sport', Icons.fitness_center),
  education('Education', Icons.school),
  entertainment('Entertainment', Icons.movie),
  cafe('Cafe', Icons.local_cafe),
  houseneeds('Houseneeds', Icons.house),
  bills('Bills', Icons.receipt_long),
  other('Other', Icons.more_horiz);

  const ExpenseCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}

class Expense {
  const Expense({
    this.id,
    required this.title,
    required this.amountCents,
    required this.date,
    required this.category,
  });

  final int? id;
  final String title;
  final int amountCents;
  final DateTime date;
  final ExpenseCategory category;

  Map<String, Object?> toMap() {
    return {
      'title': title,
      'amount_cents': amountCents,
      'date': date.toIso8601String(),
      'category': category.name,
    };
  }

  factory Expense.fromMap(Map<String, Object?> map) {
    return Expense(
      id: map['id'] as int,
      title: map['title'] as String,
      amountCents: map['amount_cents'] as int,
      date: DateTime.parse(map['date'] as String),
      category: ExpenseCategory.values.byName(map['category'] as String),
    );
  }
}
