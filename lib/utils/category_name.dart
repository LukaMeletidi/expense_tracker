import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/utils/default_categories.dart';

String categoryName(Category category, AppLocalizations l10n) {
  final isOriginal = defaultCategories.any(
    (d) => d.iconKey == category.iconKey && d.name == category.name,
  );
  if (!isOriginal) return category.name;
  return switch (category.iconKey) {
    'food' => l10n.categoryFood,
    'transport' => l10n.categoryTransport,
    'shopping' => l10n.categoryShopping,
    'health' => l10n.categoryHealth,
    'sport' => l10n.categorySport,
    'education' => l10n.categoryEducation,
    'entertainment' => l10n.categoryEntertainment,
    'cafe' => l10n.categoryCafe,
    'houseneeds' => l10n.categoryHouseneeds,
    'bills' => l10n.categoryBills,
    'other' => l10n.categoryOther,
    _ => category.name,
  };
}
