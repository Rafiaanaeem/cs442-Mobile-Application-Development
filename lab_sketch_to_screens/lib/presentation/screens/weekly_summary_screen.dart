/// S11 Weekly summary (template: DETAIL). A week's totals compared with the
/// week before. A week runs Monday to Sunday.
library;

import 'package:material_ui/material_ui.dart';

import '../../app/format.dart';
import '../../data/sample_data.dart';
import '../widgets/app_card.dart';
import '../widgets/section_title.dart';
import '../widgets/status_view.dart';

class WeeklySummaryScreen extends StatefulWidget {
  const WeeklySummaryScreen({super.key});

  @override
  State<WeeklySummaryScreen> createState() => _WeeklySummaryScreenState();
}

class _WeeklySummaryScreenState extends State<WeeklySummaryScreen> {
  /// 0 is this week so far. Opens on the last completed week.
  var _weeksBack = 1;

  String _label() {
    if (_weeksBack == 0) return 'This week so far';
    if (_weeksBack == 1) return 'Last completed week';
    final start = weekStartDaysAgo(_weeksBack);
    return '${shortDate(dateDaysAgo(start))} - '
        '${shortDate(dateDaysAgo(start - 6))}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = weekSummary(_weeksBack);
    final isOldest = _weeksBack == sampleWeekCount - 1;
    final previous = isOldest ? null : weekSummary(_weeksBack + 1);
    final untracked = summary.days - summary.trackedDays;
    final percent = summary.habitPercent;

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly summary')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Earlier week',
                icon: const Icon(Icons.chevron_left),
                onPressed: isOldest ? null : () => setState(() => _weeksBack++),
              ),
              Expanded(
                child: Text(
                  _label(),
                  key: const Key('summary-week'),
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                tooltip: 'Later week',
                icon: const Icon(Icons.chevron_right),
                onPressed: _weeksBack == 0
                    ? null
                    : () => setState(() => _weeksBack--),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (summary.isEmpty)
            const StatusView(
              icon: Icons.event_busy,
              title: 'Nothing recorded in this week',
              message:
                  'Workouts, steps and habits you record will be '
                  'summarised here.',
            )
          else ...[
            AppCard(
              icon: Icons.fitness_center,
              title: 'Workouts: ${summary.workouts} / ${summary.workoutTarget}',
              subtitle:
                  '${plural(summary.minutes, 'minute')} | '
                  '${summary.targetMet ? 'Target achieved' : 'Target not reached'}',
            ),
            AppCard(
              icon: Icons.directions_walk,
              title: summary.trackedDays == 0
                  ? 'Steps: not tracked'
                  : 'Steps: ${formatCount(summary.steps)} recorded',
              subtitle: summary.trackedDays == 0
                  ? 'No steps were recorded this week'
                  : 'Goal met on ${summary.goalMetDays} of '
                        '${plural(summary.trackedDays, 'tracked day')}'
                        '${untracked > 0 ? ' | ${plural(untracked, 'day')} not tracked' : ''}',
            ),
            AppCard(
              icon: Icons.check_circle_outline,
              title: summary.habitsDue == 0
                  ? 'Habits: none due'
                  : 'Habits: ${summary.habitsDone} / ${summary.habitsDue} due',
              subtitle: percent == null
                  ? 'No habits were scheduled this week'
                  : '$percent% of scheduled entries completed',
            ),
          ],
          const SectionTitle('Compared with the previous week'),
          for (final line in compareWeeks(summary, previous))
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(line),
            ),
          const SizedBox(height: 16),
          Text(
            'Summaries use your recorded activity. Days without step tracking '
            'are labelled, not counted as zero.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// One line per total, for example "Workouts: 3 (2 the week before)".
List<String> compareWeeks(PeriodSummary now, PeriodSummary? before) {
  if (before == null) return const ['Comparison not available yet'];
  return [
    'Workouts: ${now.workouts} (${before.workouts} the week before)',
    'Active minutes: ${now.minutes} (${before.minutes} the week before)',
    if (now.trackedDays > 0 && before.trackedDays > 0)
      'Steps: ${formatCount(now.steps)} '
          '(${formatCount(before.steps)} the week before)'
    else
      'Steps: not compared, one of the weeks was not tracked',
    if (now.habitPercent != null && before.habitPercent != null)
      'Habits completed: ${now.habitPercent}% '
          '(${before.habitPercent}% the week before)',
  ];
}
