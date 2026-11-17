import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const currencySymbols = [r'$', '€', '₾'];
const _currencyKey = 'currency_symbol';

class CurrencyNotifier extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey) ?? currencySymbols.first;
  }

  Future<void> setSymbol(String symbol) async {
    state = AsyncData(symbol);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, symbol);
  }
}

final currencySettingProvider = AsyncNotifierProvider<CurrencyNotifier, String>(
  CurrencyNotifier.new,
);

final currencySymbolProvider = Provider<String>(
  (ref) => ref.watch(currencySettingProvider).value ?? currencySymbols.first,
);
