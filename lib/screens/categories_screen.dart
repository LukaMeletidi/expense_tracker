import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/providers/categories_provider.dart';
import 'package:expense_tracker/screens/category_detail_screen.dart';
import 'package:expense_tracker/screens/category_form_screen.dart';
import 'package:expense_tracker/utils/category_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(activeCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navCategories)),
      body: categoriesAsync.when(
        error: (error, stack) =>
            Center(child: Text(l10n.errorMessage('$error'))),
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
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.needOneCategory)));
                  return false;
                }
                return true;
              },
              onDismissed: ((direction) {
                final notifier = ref.read(categoriesProvider.notifier);
                final messenger = ScaffoldMessenger.of(context);
                notifier.updateCategory(category.copyWith(isDeleted: true));
                messenger.clearSnackBars();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(l10n.categoryDeleted),
                    persist: false,
                    duration: const Duration(seconds: 4),
                    action: SnackBarAction(
                      label: l10n.undo,
                      onPressed: () => notifier.updateCategory(
                        category.copyWith(isDeleted: false),
                      ),
                    ),
                  ),
                );
              }),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: category.color.withAlpha(40),
                  child: Icon(category.icon, color: category.color),
                ),
                title: Text(categoryName(category, l10n)),
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
