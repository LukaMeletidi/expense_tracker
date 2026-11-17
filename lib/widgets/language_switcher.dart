import 'package:expense_tracker/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (code) =>
          ref.read(localeSettingProvider.notifier).setLanguage(code),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'en', child: Text('English')),
        PopupMenuItem(value: 'ka', child: Text('ქართული')),
      ],
    );
  }
}
