import 'package:expense_tracker/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: categoriesAsync.when(
        error: (error, stack) => Center(child: Text('Error $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (categories) => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (ctx, index) {
            final category = categories[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: category.color.withAlpha(40),
                child: Icon(category.icon, color: category.color),
              ),
              title: Text(category.name),
            );
          },
        ),
      ),
    );
  }
}
