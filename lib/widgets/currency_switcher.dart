import 'package:expense_tracker/providers/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencySwitcher extends ConsumerWidget {
  const CurrencySwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final symbol = ref.watch(currencySymbolProvider);

    return PopupMenuButton<String>(
      tooltip: 'Currency',
      initialValue: symbol,
      onSelected: (value) =>
          ref.read(currencySettingProvider.notifier).setSymbol(value),
      itemBuilder: (ctx) => currencySymbols
          .map((s) => PopupMenuItem<String>(value: s, child: Text(s)))
          .toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          symbol,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
