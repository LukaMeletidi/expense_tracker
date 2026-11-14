
import 'package:intl/intl.dart';

String dayLabel(DateTime day, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  if (day == today) return 'Today';
  if (day == yesterday) return 'Yesterday';
  if (day.year != now.year) return DateFormat('EEEE, d MMM y').format(day);
  return DateFormat('EEEE, d MMM').format(day);
}