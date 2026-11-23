/// S07 Habits (template: LIST). Tick off scheduled habits and see each
/// habit's streak. Ticks are kept only while the screen is open.
library;

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../app/format.dart';
import '../../data/sample_data.dart';
import '../widgets/app_shell.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_title.dart';
import '../widgets/status_view.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  /// Days before today being shown. 0 is today.
  var _daysBack = 0;

  /// "habitId@daysAgo" for every tick, starting from the sample ticks.
  final _done = {...sampleCompletions};

  bool _isDone(Habit h) => _done.contains('${h.id}@$_daysBack');

  void _toggle(Habit h, bool done) => setState(
    () => done
        ? _done.add('${h.id}@$_daysBack')
        : _done.remove('${h.id}@$_daysBack'),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = dateDaysAgo(_daysBack);
    final due = [
      for (final h in sampleHabits)
        if (h.isScheduledOn(date)) h,
    ];
    final notDue = [
      for (final h in sampleHabits)
        if (!h.isScheduledOn(date)) h,
    ];
    final doneCount = due.where(_isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
        actions: const [SettingsAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Previous day',
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() => _daysBack++),
              ),
              Expanded(
                child: Text(
                  dayLabel(_daysBack),
                  key: const Key('habits-day'),
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                tooltip: 'Next day',
                icon: const Icon(Icons.chevron_right),
                // Habits cannot be ticked for days that have not happened.
                onPressed: _daysBack == 0
                    ? null
                    : () => setState(() => _daysBack--),
              ),
            ],
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            key: const Key('add-habit'),
            label: 'Add habit',
            onPressed: () => context.push('/habits/edit'),
          ),
          const SizedBox(height: 8),
          if (sampleHabits.isEmpty)
            const StatusView(
              icon: Icons.check_circle_outline,
              title: 'No habits yet',
              message:
                  'Add a habit to start a streak. '
                  'You can write your own or pick a fitness template.',
            )
          else if (due.isEmpty)
            const StatusView(
              icon: Icons.event_available,
              title: 'Nothing scheduled for this day',
              message: 'Days without a scheduled habit do not affect streaks.',
            )
          else ...[
            for (final h in due)
              Card(
                key: ValueKey(h.id),
                child: CheckboxListTile(
                  key: Key('habit-check-${h.id}'),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _isDone(h),
                  onChanged: (v) => _toggle(h, v ?? false),
                  title: Text(h.name),
                  subtitle: Text(
                    '${h.streak}-day streak | ${scheduleLabel(h.weekdays)}',
                  ),
                  secondary: TextButton(
                    onPressed: () => context.push('/habits/edit?id=${h.id}'),
                    child: const Text('Edit'),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '$doneCount of ${due.length} scheduled habits complete',
                key: const Key('habits-count'),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
          if (notDue.isNotEmpty && due.isNotEmpty) ...[
            const SectionTitle('Not scheduled for this day'),
            for (final h in notDue)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(h.name),
                subtitle: Text(scheduleLabel(h.weekdays)),
                trailing: TextButton(
                  onPressed: () => context.push('/habits/edit?id=${h.id}'),
                  child: const Text('Edit'),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
