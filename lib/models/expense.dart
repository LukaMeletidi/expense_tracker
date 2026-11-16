class Expense {
  const Expense({
    this.id,
    required this.title,
    required this.amountCents,
    required this.date,
    required this.categoryId,
  });

  final int? id;
  final String title;
  final int amountCents;
  final DateTime date;
  final int categoryId;

  Map<String, Object?> toMap() {
    return {
      'title': title,
      'amount_cents': amountCents,
      'date': date.toIso8601String(),
      'category_id': categoryId,
    };
  }

  factory Expense.fromMap(Map<String, Object?> map) {
    return Expense(
      id: map['id'] as int,
      title: map['title'] as String,
      amountCents: map['amount_cents'] as int,
      date: DateTime.parse(map['date'] as String),
      categoryId: map['category_id'] as int,
    );
  }
}
