/// S05 Exercise catalogue (template: SEARCH, a TextField on top then a LIST).
/// Searches the sample exercises; the wger REST API replaces them later.
library;

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../data/sample_data.dart';
import '../widgets/app_card.dart';
import '../widgets/image_placeholder.dart';
import '../widgets/section_title.dart';
import '../widgets/status_view.dart';

class ExerciseCatalogueScreen extends StatefulWidget {
  const ExerciseCatalogueScreen({super.key, this.picking = false});

  /// True when the workout log opened this screen to get an exercise back.
  final bool picking;

  @override
  State<ExerciseCatalogueScreen> createState() =>
      _ExerciseCatalogueScreenState();
}

class _ExerciseCatalogueScreenState extends State<ExerciseCatalogueScreen> {
  var _search = '';
  String? _equipment;
  String? _category;
  var _grid = false;

  List<Exercise> get _results => [
    for (final e in sampleExercises)
      if (e.name.toLowerCase().contains(_search.trim().toLowerCase()) &&
          (_equipment == null || e.equipment.contains(_equipment)) &&
          (_category == null || e.category == _category))
        e,
  ];

  /// The detail screen returns the exercise when "Add to workout" is pressed.
  Future<void> _openDetail(Exercise exercise) async {
    final added = await context.push<Exercise>('/exercises/${exercise.id}');
    if (added == null || !mounted) return;
    if (widget.picking) {
      context.pop(added); // back to the workout log, with the exercise
    } else {
      context.pushReplacement('/workouts/log?mode=live&add=${added.id}');
    }
  }

  Future<void> _addManual() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _ManualExerciseDialog(initial: _search.trim()),
    );
    if (name == null || name.isEmpty || !mounted) return;
    context.pop(
      Exercise(
        id: 'manual',
        name: name,
        category: 'Manual',
        equipment: const [],
        muscles: const [],
        description: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = _results;
    return Scaffold(
      appBar: AppBar(title: const Text('Find an exercise')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('exercise-search'),
            decoration: const InputDecoration(
              labelText: 'Search',
              hintText: 'Exercise name',
              prefixIcon: Icon(Icons.search),
            ),
            textInputAction: TextInputAction.search,
            onChanged: (text) => setState(() => _search = text),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FilterMenu(
                  label: 'Equipment',
                  options: exerciseEquipment,
                  selected: _equipment,
                  onSelected: (v) => setState(() => _equipment = v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FilterMenu(
                  label: 'Category',
                  options: exerciseCategories,
                  selected: _category,
                  onSelected: (v) => setState(() => _category = v),
                ),
              ),
            ],
          ),
          SectionTitle(
            'Exercise catalogue',
            trailing: IconButton(
              key: const Key('toggle-grid'),
              tooltip: _grid ? 'Show as list' : 'Show as grid',
              icon: Icon(_grid ? Icons.view_list : Icons.grid_view),
              onPressed: () => setState(() => _grid = !_grid),
            ),
          ),
          if (results.isEmpty)
            const StatusView(
              icon: Icons.search_off,
              title: 'No exercises found',
              message:
                  'Try another name or filter, '
                  'or add the exercise by hand.',
            )
          else if (_grid)
            // Stretch goal: the same results as a grid.
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.9,
              children: [
                for (final e in results)
                  _ExerciseTile(exercise: e, onTap: () => _openDetail(e)),
              ],
            )
          else
            for (final e in results)
              AppCard(
                key: ValueKey(e.id),
                icon: e.icon,
                heroTag: 'exercise-${e.id}',
                title: e.name,
                subtitle: e.subtitle,
                onTap: () => _openDetail(e),
              ),
          const SizedBox(height: 8),
          // Only while picking: a manual exercise goes straight into the log.
          if (widget.picking)
            TextButton.icon(
              key: const Key('manual-exercise'),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Add a manual exercise'),
              onPressed: _addManual,
            ),
          const SizedBox(height: 8),
          Text(
            'Sample exercises for the lab. The app loads them from wger '
            '(wger.de), licensed CC-BY-SA.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// A grid tile: picture on top, name and category below.
class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({required this.exercise, required this.onTap});

  final Exercise exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: ValueKey('tile-${exercise.id}'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Hero(
                  tag: 'exercise-${exercise.id}',
                  child: ImagePlaceholder(
                    icon: exercise.icon,
                    aspectRatio: null,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                exercise.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall,
              ),
              Text(
                exercise.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A box that opens a list of filter options. "Any" clears the filter.
class _FilterMenu extends StatelessWidget {
  const _FilterMenu({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final List<String> options;
  final String? selected;
  final void Function(String? value) onSelected;

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    tooltip: label,
    // An empty string stands for "Any".
    onSelected: (v) => onSelected(v.isEmpty ? null : v),
    itemBuilder: (context) => [
      const PopupMenuItem(value: '', child: Text('Any')),
      for (final o in options) PopupMenuItem(value: o, child: Text(o)),
    ],
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      child: Text(
        selected ?? 'Any',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

class _ManualExerciseDialog extends StatefulWidget {
  const _ManualExerciseDialog({required this.initial});

  final String initial;

  @override
  State<_ManualExerciseDialog> createState() => _ManualExerciseDialogState();
}

class _ManualExerciseDialogState extends State<_ManualExerciseDialog> {
  late final _name = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Manual exercise'),
    content: TextField(
      key: const Key('manual-exercise-name'),
      controller: _name,
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(labelText: 'Exercise name'),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, _name.text.trim()),
        child: const Text('Add to workout'),
      ),
    ],
  );
}
