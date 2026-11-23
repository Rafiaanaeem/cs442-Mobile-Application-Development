/// S06 Exercise detail (template: DETAIL). Read about an exercise before
/// adding it. The picture flies in from the catalogue (Hero animation).
library;

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../data/sample_data.dart';
import '../widgets/app_shell.dart';
import '../widgets/image_placeholder.dart';
import '../widgets/info_row.dart';
import '../widgets/primary_button.dart';
import '../widgets/status_view.dart';

class ExerciseDetailScreen extends StatelessWidget {
  const ExerciseDetailScreen({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final e = exerciseById(exerciseId);
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise detail')),
      body: e == null
          ? const Center(
              child: StatusView(
                icon: Icons.search_off,
                title: 'Exercise not found',
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(e.name, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                Hero(
                  tag: 'exercise-${e.id}',
                  child: ImagePlaceholder(icon: e.icon),
                ),
                const SizedBox(height: 16),
                InfoRow(label: 'Category', value: e.category),
                InfoRow(label: 'Muscles', value: e.muscles.join(', ')),
                InfoRow(label: 'Equipment', value: e.equipment.join(', ')),
                const SizedBox(height: 12),
                Text(
                  e.description.isEmpty
                      ? 'No description is provided for this exercise.'
                      : e.description,
                ),
                const SizedBox(height: 16),
                Text(
                  'Source: sample data (wger.de in the app). '
                  'Licence: CC-BY-SA.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  key: const Key('add-to-workout'),
                  label: 'Add to workout',
                  onPressed: () => context.pop(e),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => showSnack(
                    context,
                    'Opens the exercise on wger.de once url_launcher is added.',
                  ),
                  child: const Text('View source'),
                ),
              ],
            ),
    );
  }
}
