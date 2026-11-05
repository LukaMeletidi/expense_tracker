import 'package:flutter/material.dart';

enum ExpenseCategory {
  food('Food', Icons.restaurant, Colors.orange),
  transport('Transport', Icons.subway, Colors.blue),
  shopping('Shopping', Icons.shopping_cart, Colors.pink),
  health('Health', Icons.health_and_safety, Colors.red),
  sport('Sport', Icons.fitness_center, Colors.green),
  education('Education', Icons.school, Colors.indigo),
  entertainment('Entertainment', Icons.movie, Colors.purple),
  cafe('Cafe', Icons.local_cafe, Colors.brown),
  houseneeds('Houseneeds', Icons.house, Colors.teal),
  bills('Bills', Icons.receipt_long, Colors.blueGrey),
  other('Other', Icons.more_horiz, Colors.grey);

  const ExpenseCategory(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
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
