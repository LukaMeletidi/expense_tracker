import 'package:expense_tracker/providers/currency_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('currency provider', () {
    test('uses the dollar sign when nothing is saved', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(currencySettingProvider.future);
      expect(container.read(currencySymbolProvider), r'$');
    });
    test('loads the saved symbol', () async {
      SharedPreferences.setMockInitialValues({'currency_symbol': '₾'});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(currencySettingProvider.future);
      expect(container.read(currencySymbolProvider), '₾');
    });
    test('setSymbol changes the symbol and saves it', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(currencySettingProvider.future);
      await container.read(currencySettingProvider.notifier).setSymbol('€');
      expect(container.read(currencySymbolProvider), '€');
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('currency_symbol'), '€');
    });
  });
}
