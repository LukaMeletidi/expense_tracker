import 'package:flutter/material.dart';

const categoryIcons = <String, IconData>{
  'food': Icons.restaurant,
  'cafe': Icons.local_cafe,
  'houseneeds': Icons.home,
  'bills': Icons.receipt_long,
  'education': Icons.school,
  'transport': Icons.subway,
  'health': Icons.health_and_safety,
  'shopping': Icons.shopping_cart,
  'entertainment': Icons.movie,
  'travel': Icons.flight,
  'gift': Icons.card_giftcard,
  'pets': Icons.pets,
  'phone': Icons.phone_android,
  'sport': Icons.fitness_center,
  'other': Icons.more_horiz,
};

IconData iconFor(String key) => categoryIcons[key] ?? Icons.category;
