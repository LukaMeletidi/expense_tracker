
class BudgetProgress {
  const BudgetProgress({required this.spentCents, required this.limitCents});

  final int spentCents;
  final int limitCents;

  double get ratio => limitCents <= 0 ? 0 : spentCents / limitCents;
  double get barValue => ratio > 1 ? 1 : ratio;
  int get remainingCents => limitCents - spentCents;
  bool get isOver => spentCents > limitCents;
}