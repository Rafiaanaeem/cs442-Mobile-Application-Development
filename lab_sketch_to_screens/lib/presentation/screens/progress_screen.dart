/// S10 Progress (template: LIST). Steps chart, workout and habit totals for
/// this week or this month.
library;

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../app/format.dart';
import '../../data/sample_data.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_title.dart';
import '../widgets/status_view.dart';
import '../widgets/step_bar_chart.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  var _month = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = _month ? monthSummary() : weekSummary(0);
    final bars = _month ? monthBars(stepsOn) : weekBars(stepsOn);
    final period = _month ? 'this month' : 'this week';
    final percent = summary.habitPercent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        actions: const [SettingsAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('This week')),
              ButtonSegment(value: true, label: Text('This month')),
            ],
            selected: {_month},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _month = s.first),
          ),
          const SectionTitle('Step history'),
          if (summary.trackedDays == 0)
            StatusView(
              icon: Icons.directions_walk,
              title: 'No steps recorded $period',
              message: 'Turn on step tracking to fill this chart.',
              actionLabel: 'Set up step tracking',
              onAction: () => context.push('/steps'),
            )
          else ...[
            StepBarChart(bars: bars, goal: sampleProfile.stepGoal),
            const SizedBox(height: 8),
            Text(
              '${formatCount(summary.steps)} steps on '
              '${plural(summary.trackedDays, 'tracked day')}. '
              'Days without recording are left empty. '
              'The line is your daily goal.',
              style: theme.textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 12),
          AppCard(
            icon: Icons.fitness_center,
            title: _month
                ? 'Workouts: ${summary.workouts}'
                : 'Workouts: ${summary.workouts} / ${summary.workoutTarget}',
            subtitle: '${plural(summary.minutes, 'minute')} logged $period',
            onTap: () => context.go('/workouts'),
          ),
          AppCard(
            icon: Icons.check_circle_outline,
            title: summary.habitsDue == 0
                ? 'Habits: none due yet'
                : 'Habits: ${summary.habitsDone} / ${summary.habitsDue} due',
            subtitle: percent == null
                ? 'Scheduled habits will be counted here'
                : '$percent% of scheduled entries completed',
            onTap: () => context.go('/habits'),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Open weekly summary',
            onPressed: () => context.push('/summary'),
          ),
        ],
      ),
    );
  }
}
