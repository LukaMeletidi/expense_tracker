import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/providers/categories_provider.dart';
import 'package:expense_tracker/screens/category_form_screen.dart';
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
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: categories.length,
          itemBuilder: (ctx, index) {
            final category = categories[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: category.color.withAlpha(40),
                child: Icon(category.icon, color: category.color),
              ),
              title: Text(category.name),
              onTap: () async {
                final updated = await Navigator.push<Category>(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => CategoryFormScreen(category: category),
                  ),
                );
                if (!context.mounted || updated == null) return;
                ref.read(categoriesProvider.notifier).updateCategory(updated);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCategory = await Navigator.push<Category>(
            context,
            MaterialPageRoute(builder: (ctx) => const CategoryFormScreen()),
          );
          if (!context.mounted || newCategory == null) return;
          ref.read(categoriesProvider.notifier).addCategory(newCategory);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
