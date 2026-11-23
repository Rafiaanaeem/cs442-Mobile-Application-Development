/// Small text helpers shared by the screens. No packages needed.
library;

const weekdayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const weekdayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
const monthShort = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Today at midnight.
DateTime today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// The date [daysAgo] days before today.
DateTime dateDaysAgo(int daysAgo) {
  final t = today();
  return DateTime(t.year, t.month, t.day - daysAgo);
}

/// 6300 -> "6,300".
String formatCount(int n) {
  final digits = n.abs().toString();
  final out = StringBuffer(n < 0 ? '-' : '');
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write(',');
    out.write(digits[i]);
  }
  return out.toString();
}

/// "9 Nov".
String shortDate(DateTime d) => '${d.day} ${monthShort[d.month - 1]}';

/// "Today", "Yesterday" or "Mon 9 Nov".
String dayLabel(int daysAgo) {
  if (daysAgo == 0) return 'Today';
  if (daysAgo == 1) return 'Yesterday';
  final d = dateDaysAgo(daysAgo);
  return '${weekdayShort[d.weekday - 1]} ${shortDate(d)}';
}

/// 1140 -> "19:00".
String formatMinutes(int minutesOfDay) =>
    '${(minutesOfDay ~/ 60).toString().padLeft(2, '0')}:'
    '${(minutesOfDay % 60).toString().padLeft(2, '0')}';

/// 754 seconds -> "00:12:34".
String formatClock(int seconds) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(seconds ~/ 3600)}:${two(seconds % 3600 ~/ 60)}:'
      '${two(seconds % 60)}';
}

/// plural(1, 'session') -> "1 session", plural(3, 'session') -> "3 sessions".
String plural(int n, String one, [String? many]) =>
    '$n ${n == 1 ? one : (many ?? '${one}s')}';

/// "Every day" or "Mon / Wed / Fri".
String scheduleLabel(Set<int> weekdays) {
  if (weekdays.length == 7) return 'Every day';
  final sorted = weekdays.toList()..sort();
  return sorted.map((d) => weekdayShort[d - 1]).join(' / ');
}
