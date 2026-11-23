/// S03 Workout history (template: LIST). Past sessions and the two ways to
/// add one.
library;

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../data/sample_data.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_title.dart';
import '../widgets/status_view.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final week = weekSummary(0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(
            tooltip: 'Browse exercises',
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/exercises'),
          ),
          const SettingsAction(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'Start workout',
                  onPressed: () => context.push('/workouts/log?mode=live'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SecondaryButton(
                  label: 'Log past workout',
                  onPressed: () => context.push('/workouts/log?mode=past'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppCard(
            icon: Icons.flag_outlined,
            title: 'Weekly target: ${week.workouts} / ${week.workoutTarget}',
            subtitle: 'Manage target in Settings',
            onTap: () => context.push('/settings'),
          ),
          const SectionTitle('History'),
          if (sampleWorkouts.isEmpty)
            const StatusView(
              icon: Icons.fitness_center_outlined,
              title: 'No workouts yet',
              message:
                  'Start a workout or log a past one. It will appear here.',
            )
          else ...[
            for (final w in sampleWorkouts)
              AppCard(
                key: ValueKey(w.id),
                icon: w.type == WorkoutType.timed
                    ? Icons.timer_outlined
                    : Icons.fitness_center,
                title: w.title,
                subtitle: w.description,
                onTap: () => context.push('/workouts/log?id=${w.id}'),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Tap a workout to view or edit.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
