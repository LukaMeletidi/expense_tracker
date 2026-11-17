import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

String dayLabel(DateTime day, DateTime now, AppLocalizations l10n) {
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  if (day == today) return l10n.today;
  if (day == yesterday) return l10n.yesterday;
  if (day.year != now.year) {
    return DateFormat('EEEE, d MMM y', l10n.localeName).format(day);
  }
  return DateFormat('EEEE, d MMM', l10n.localeName).format(day);
}
