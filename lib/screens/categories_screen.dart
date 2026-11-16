import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/providers/categories_provider.dart';
import 'package:expense_tracker/screens/category_detail_screen.dart';
import 'package:expense_tracker/screens/category_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(activeCategoriesProvider);

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
            return Dismissible(
              key: ValueKey(category.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Theme.of(context).colorScheme.error,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
              confirmDismiss: (direction) async {
                if (categories.length <= 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You need at least one category'),
                    ),
                  );
                  return false;
                }
                return showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete category'),
                    content: const Text(
                      'Existing expenses will keep this category.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx, false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx, true);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: ((direction) => ref
                  .read(categoriesProvider.notifier)
                  .updateCategory(category.copyWith(isDeleted: true))),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: category.color.withAlpha(40),
                  child: Icon(category.icon, color: category.color),
                ),
                title: Text(category.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) =>
                          CategoryDetailScreen(categoryId: category.id!),
                    ),
                  );
                },
              ),
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
