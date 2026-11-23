/// Welcome (template: centred column). Logo, title, one button.
library;

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../widgets/disclaimer_text.dart';
import '../widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Icon(
                        Icons.fitness_center,
                        size: 56,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Fitness and Habit Tracker',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Track effort. Build consistency.',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Log workouts, reach a daily step goal, keep your habits '
                  'going and review your week.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Get started',
                  onPressed: () => context.push('/login?mode=create'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.push('/login'),
                  child: const Text('I already have an account'),
                ),
                const SizedBox(height: 24),
                const DisclaimerText(textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
