// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Expense Tracker';

  @override
  String get navExpenses => 'Expenses';

  @override
  String get navCategories => 'Categories';

  @override
  String get navBudgets => 'Budgets';

  @override
  String get searchByName => 'Search by name';

  @override
  String get periodDay => 'Day';

  @override
  String get periodWeek => 'Week';

  @override
  String get periodMonth => 'Month';

  @override
  String get periodYear => 'Year';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get undo => 'Undo';

  @override
  String get currency => 'Currency';

  @override
  String get category => 'Category';

  @override
  String get selectCategory => 'Select a category';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get editExpense => 'Edit Expense';

  @override
  String get title => 'Title';

  @override
  String get enterTitle => 'Please enter a title';

  @override
  String get amount => 'Amount';

  @override
  String get enterValidAmount => 'Please enter a valid amount';

  @override
  String get newBudget => 'New Budget';

  @override
  String get editBudget => 'Edit Budget';

  @override
  String get monthlyLimit => 'Monthly limit';

  @override
  String get newCategory => 'New Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get name => 'Name';

  @override
  String get enterName => 'Please enter a name';

  @override
  String get icon => 'Icon';

  @override
  String get color => 'Color';

  @override
  String get noBudgetsYet =>
      'No budgets yet.\nTap + to set a monthly limit for a category';

  @override
  String get budgetDeleted => 'Budget deleted';

  @override
  String get allCategoriesHaveBudget => 'All categories already have a budget';

  @override
  String get needOneCategory => 'You need at least one category';

  @override
  String get categoryDeleted => 'Category deleted';

  @override
  String get expenseDeleted => 'Expense deleted';

  @override
  String get noExpensesFound => 'No expenses found';

  @override
  String get noExpensesInPeriod => 'No expenses in this period';

  @override
  String errorMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get unknownCategory => 'Unknown';

  @override
  String budgetSpentOf(String spent, String limit) {
    return '$spent of $limit';
  }

  @override
  String budgetLeft(String amount) {
    return '$amount left';
  }

  @override
  String budgetOver(String amount) {
    return '$amount over';
  }
}
