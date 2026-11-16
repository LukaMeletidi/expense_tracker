class Budget {
  const Budget({this.id, required this.categoryId, required this.limitCents});

  final int? id;
  final int categoryId;
  final int limitCents;

  Budget copywith({int? id, int? categoryId, int? limitCents}) {
    return Budget(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      limitCents: limitCents ?? this.limitCents,
    );
  }

  Map<String, Object?> toMap() => {
    'id': id,
    'category_id': categoryId,
    'limit_cents': limitCents,
  };

  factory Budget.fromMap(Map<String, Object?> map) => Budget(
    id: map['id'] as int,
    categoryId: map['category_id'] as int,
    limitCents: map['limit_cents'] as int,
  );
}
