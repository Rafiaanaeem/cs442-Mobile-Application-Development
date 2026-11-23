/// S09 Steps and daily goal (template: DETAIL). Recorded steps, the goal
/// streak and the daily target. The step sensor and the activity permission
/// plug in during the hardware session.
library;

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app/format.dart';
import '../../data/sample_data.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_title.dart';

const minStepGoal = 1000;
const maxStepGoal = 100000;

class StepsScreen extends StatefulWidget {
  const StepsScreen({super.key});

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  final _goalText = TextEditingController(text: '${sampleProfile.stepGoal}');
  var _goal = sampleProfile.stepGoal;
  var _tracking = true;
  String? _goalError;

  @override
  void dispose() {
    _goalText.dispose();
    super.dispose();
  }

  void _saveGoal() {
    final goal = int.tryParse(_goalText.text);
    if (goal == null || goal < minStepGoal || goal > maxStepGoal) {
      setState(
        () => _goalError =
            'Enter a goal between '
            '${formatCount(minStepGoal)} and ${formatCount(maxStepGoal)}',
      );
      return;
    }
    setState(() {
      _goalError = null;
      _goal = goal;
    });
    showSnack(context, 'Daily goal saved');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = stepsOn(0) ?? 0;
    final streak = stepStreak();

    return Scaffold(
      appBar: AppBar(title: const Text('Steps & goal')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Today', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          if (_tracking) ...[
            Text(
              '${formatCount(steps)} / ${formatCount(_goal)}',
              key: const Key('steps-today'),
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: (steps / _goal).clamp(0.0, 1.0),
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 12),
            Text(
              streak == 0 ? 'No goal streak yet' : '$streak-day goal streak',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              steps >= _goal
                  ? 'Goal reached today.'
                  : 'Today is still in progress.',
            ),
          ] else
            Text(
              'Step tracking is off',
              key: const Key('steps-off'),
              style: theme.textTheme.headlineSmall,
            ),
          const SizedBox(height: 20),
          TextField(
            key: const Key('step-goal'),
            controller: _goalText,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: InputDecoration(
              labelText: 'Daily step goal',
              errorText: _goalError,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: _saveGoal,
              child: const Text('Save goal'),
            ),
          ),
          const SectionTitle('Step tracking'),
          if (_tracking) ...[
            const AppCard(
              icon: Icons.sensors,
              title: 'Tracking: on',
              subtitle:
                  'Recording since 06:42 today. Steps taken while the '
                  'app is closed are added when you open it again.',
            ),
            const SizedBox(height: 8),
            SecondaryButton(
              label: 'Turn off step tracking',
              onPressed: () => setState(() => _tracking = false),
            ),
          ] else ...[
            const AppCard(
              icon: Icons.sensors_off,
              title: 'Tracking: off',
              subtitle:
                  'To count steps, the app needs access to your '
                  'physical activity. It is used only for your step total.',
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              key: const Key('enable-steps'),
              label: 'Enable step tracking',
              onPressed: () => setState(() => _tracking = true),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Continue without tracking'),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'Counts may be incomplete if tracking stops.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
