import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeKey = 'language_code';

class LocaleNotifier extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeKey);
  }

  Future<void> setLanguage(String code) async {
    state = AsyncData(code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, code);
  }
}

final localeSettingProvider = AsyncNotifierProvider<LocaleNotifier, String?>(
  LocaleNotifier.new,
);

final localeProvider = Provider<Locale?>((ref) {
  final code = ref.watch(localeSettingProvider).value;
  return code == null ? null : Locale(code);
});
