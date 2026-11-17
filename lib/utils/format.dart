
String formatCents(int cents, String symbol) {
  return '${(cents / 100).toStringAsFixed(2)} $symbol';
}

