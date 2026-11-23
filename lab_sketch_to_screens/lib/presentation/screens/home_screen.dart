/// S02 Home (template: LIST). Today's activity and the next action.
library;

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../app/format.dart';
import '../../data/sample_data.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = stepsOn(0) ?? 0;
    final goal = sampleProfile.stepGoal;

    final dueToday = [
      for (final h in sampleHabits)
        if (h.isScheduledOn(today())) h,
    ];
    final doneToday = dueToday
        .where((h) => sampleCompletions.contains('${h.id}@0'))
        .length;
    final streaks = [
      for (final h in sampleHabits)
        if (h.streak > 0) '${h.name}: ${h.streak}-day streak',
    ];

    final week = weekSummary(0);
    final left = week.workoutTarget - week.workouts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: const [SettingsAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SectionTitle('Your progress today'),
          AppCard(
            icon: Icons.directions_walk,
            title: 'Steps: ${formatCount(steps)} / ${formatCount(goal)}',
            subtitle: steps >= goal
                ? 'Daily goal reached'
                : 'Open steps and daily goal',
            footer: LinearProgressIndicator(
              value: (steps / goal).clamp(0.0, 1.0),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            onTap: () => context.push('/steps'),
          ),
          AppCard(
            icon: Icons.check_circle_outline,
            title: dueToday.isEmpty
                ? 'Habits: none scheduled today'
                : 'Habits: $doneToday of ${dueToday.length} complete',
            subtitle: streaks.isEmpty
                ? 'Tick a habit to start a streak'
                : streaks.take(2).join(' | '),
            onTap: () => context.go('/habits'),
          ),
          AppCard(
            icon: Icons.fitness_center,
            title:
                'Workouts this week: ${week.workouts} / ${week.workoutTarget}',
            subtitle: left <= 0
                ? 'Weekly target reached'
                : '${plural(left, 'session')} left to reach your target',
            onTap: () => context.go('/workouts'),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Start workout',
            onPressed: () => context.push('/workouts/log?mode=live'),
          ),
          const SizedBox(height: 8),
          SecondaryButton(
            label: 'Log a past workout',
            onPressed: () => context.push('/workouts/log?mode=past'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.push('/summary'),
            child: const Text('View weekly summary'),
          ),
          Text(
            'Some changes are waiting to sync.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
