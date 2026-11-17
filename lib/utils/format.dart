
String formatCents(int cents, [String symbol = r'$']) {
  return '${(cents / 100).toStringAsFixed(2)} $symbol';
}

