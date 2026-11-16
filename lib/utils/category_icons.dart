import 'package:flutter/material.dart';

const categoryIcons = <String, IconData>{
  'food': Icons.restaurant,
  'cafe': Icons.local_cafe,
  'home': Icons.home,
  'bills': Icons.receipt_long,
  'education': Icons.school,
  'transport': Icons.directions_bus,
  'health': Icons.favorite,
  'shopping': Icons.shopping_bag,
  'fun': Icons.sports_esports,
  'travel': Icons.flight,
  'gift': Icons.card_giftcard,
  'pets': Icons.pets,
  'phone': Icons.phone_android,
  'fitness': Icons.fitness_center,
  'other': Icons.category,
};

IconData iconFor(String key) => categoryIcons[key] ?? Icons.category;