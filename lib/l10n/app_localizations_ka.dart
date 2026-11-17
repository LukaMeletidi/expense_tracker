// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get appTitle => 'ხარჯების აღრიცხვა';

  @override
  String get navExpenses => 'ხარჯები';

  @override
  String get navCategories => 'კატეგორიები';

  @override
  String get navBudgets => 'ბიუჯეტი';

  @override
  String get searchByName => 'ძებნა სახელით';

  @override
  String get periodDay => 'დღე';

  @override
  String get periodWeek => 'კვირა';

  @override
  String get periodMonth => 'თვე';

  @override
  String get periodYear => 'წელი';

  @override
  String get today => 'დღეს';

  @override
  String get yesterday => 'გუშინ';

  @override
  String get cancel => 'გაუქმება';

  @override
  String get save => 'შენახვა';

  @override
  String get undo => 'დაბრუნება';

  @override
  String get currency => 'ვალუტა';

  @override
  String get category => 'კატეგორია';

  @override
  String get selectCategory => 'აირჩიე კატეგორია';

  @override
  String get addExpense => 'ხარჯის დამატება';

  @override
  String get editExpense => 'ხარჯის რედაქტირება';

  @override
  String get title => 'დასახელება';

  @override
  String get enterTitle => 'შეიყვანე დასახელება';

  @override
  String get amount => 'თანხა';

  @override
  String get enterValidAmount => 'შეიყვანე სწორი თანხა';

  @override
  String get newBudget => 'ახალი ბიუჯეტი';

  @override
  String get editBudget => 'ბიუჯეტის რედაქტირება';

  @override
  String get monthlyLimit => 'თვიური ლიმიტი';

  @override
  String get newCategory => 'ახალი კატეგორია';

  @override
  String get editCategory => 'კატეგორიის რედაქტირება';

  @override
  String get name => 'სახელი';

  @override
  String get enterName => 'შეიყვანე სახელი';

  @override
  String get icon => 'ხატულა';

  @override
  String get color => 'ფერი';

  @override
  String get noBudgetsYet =>
      'ბიუჯეტები ჯერ არ არის.\nდააჭირე +-ს, რომ კატეგორიას თვიური ლიმიტი დაუწესო';

  @override
  String get budgetDeleted => 'ბიუჯეტი წაიშალა';

  @override
  String get allCategoriesHaveBudget => 'ყველა კატეგორიას უკვე აქვს ბიუჯეტი';

  @override
  String get needOneCategory => 'საჭიროა მინიმუმ ერთი კატეგორია';

  @override
  String get categoryDeleted => 'კატეგორია წაიშალა';

  @override
  String get expenseDeleted => 'ხარჯი წაიშალა';

  @override
  String get noExpensesFound => 'ხარჯები ვერ მოიძებნა';

  @override
  String get noExpensesInPeriod => 'ამ პერიოდში ხარჯები არ არის';

  @override
  String errorMessage(String message) {
    return 'შეცდომა: $message';
  }

  @override
  String get unknownCategory => 'უცნობი';

  @override
  String budgetSpentOf(String spent, String limit) {
    return '$spent / $limit';
  }

  @override
  String budgetLeft(String amount) {
    return 'დარჩენილია $amount';
  }

  @override
  String budgetOver(String amount) {
    return 'გადაჭარბებულია $amount';
  }
}
