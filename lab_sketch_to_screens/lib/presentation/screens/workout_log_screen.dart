/// S04 Workout log (template: FORM). Record a live session, enter a past
/// workout, or edit a saved one. Firestore saving plugs in later; today
/// "Finish and save" opens the success screen.
library;

import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app/format.dart';
import '../../data/sample_data.dart';
import '../widgets/app_shell.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_title.dart';
import '../widgets/status_view.dart';
import 'result_screen.dart';

enum LogMode { live, past, edit }

/// A set row that the form can change.
class _SetRow {
  _SetRow(this.reps, this.kg, this.done);

  int reps;
  double? kg;
  bool done;
}

/// An exercise with its rows of sets.
class _ExerciseRows {
  _ExerciseRows(this.name, this.sets);

  final String name;
  final List<_SetRow> sets;

  factory _ExerciseRows.from(WorkoutExercise e) => _ExerciseRows(e.name, [
    for (final s in e.sets) _SetRow(s.reps, s.kg, s.done),
  ]);
}

class WorkoutLogScreen extends StatefulWidget {
  const WorkoutLogScreen({
    super.key,
    this.mode,
    this.workoutId,
    this.addExerciseId,
  });

  /// 'live' or 'past' for a new workout.
  final String? mode;

  /// Set when editing a saved workout.
  final String? workoutId;

  /// Starts the workout with this exercise (from the exercise catalogue).
  final String? addExerciseId;

  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final _title = TextEditingController();
  late LogMode _mode;
  var _type = WorkoutType.strength;
  var _exercises = <_ExerciseRows>[];
  var _day = today();
  var _startMinutes = 18 * 60;
  var _minutes = 0;
  var _restoredDraft = false;
  var _found = true;

  // Live session clock.
  var _elapsed = 0;
  var _running = true;
  Timer? _ticker;

  /// Changes when rows are added or removed, so text fields rebuild with the
  /// right values instead of keeping the text of a row that moved.
  var _layoutVersion = 0;

  @override
  void initState() {
    super.initState();
    final saved = widget.workoutId == null
        ? null
        : workoutById(widget.workoutId!);
    if (widget.workoutId != null) {
      _mode = LogMode.edit;
      _found = saved != null;
      if (saved != null) _load(saved);
    } else if (widget.mode == 'past') {
      _mode = LogMode.past;
    } else {
      _mode = LogMode.live;
      if (widget.addExerciseId == null) {
        // Shows what a saved draft looks like when it is reopened.
        _load(sampleDraft);
        _restoredDraft = true;
        _elapsed = sampleDraftElapsedSeconds;
      }
    }
    final add = widget.addExerciseId == null
        ? null
        : exerciseById(widget.addExerciseId!);
    if (add != null) {
      _exercises.add(_ExerciseRows(add.name, [_SetRow(0, null, false)]));
    }

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _mode == LogMode.live && _running) {
        setState(() => _elapsed++);
      }
    });
  }

  void _load(Workout w) {
    _title.text = w.title;
    _type = w.type;
    _exercises = [for (final e in w.exercises) _ExerciseRows.from(e)];
    _day = dateDaysAgo(w.daysAgo);
    _startMinutes = w.startMinutes;
    _minutes = w.minutes;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _title.dispose();
    super.dispose();
  }

  void _relayout(VoidCallback change) => setState(() {
    change();
    _layoutVersion++;
  });

  Future<void> _addExercise() async {
    final picked = await context.push<Exercise>('/exercises?pick=true');
    if (picked != null) {
      _relayout(
        () => _exercises.add(
          _ExerciseRows(picked.name, [_SetRow(0, null, false)]),
        ),
      );
    }
  }

  void _save() {
    if (_type == WorkoutType.timed && _mode != LogMode.live && _minutes == 0) {
      showSnack(context, 'Enter how many minutes the activity took.');
      return;
    }
    final name = _title.text.trim().isEmpty ? 'Workout' : _title.text.trim();
    context.go(
      resultLocation(
        ResultKind.success,
        title: _mode == LogMode.edit ? 'Changes saved' : 'Workout saved',
        message:
            '$name is in your history. Your charts and weekly totals '
            'include it.',
        next: '/workouts',
      ),
    );
  }

  Future<void> _discardOrDelete() async {
    final editing = _mode == LogMode.edit;
    final ok = await confirm(
      context,
      title: editing ? 'Delete workout?' : 'Discard draft?',
      message: editing
          ? 'This removes the workout from your history, charts and weekly '
                'totals.'
          : 'Everything entered for this workout will be removed.',
      action: editing ? 'Delete' : 'Discard',
    );
    if (!ok || !mounted) return;
    showSnack(context, editing ? 'Workout deleted' : 'Draft discarded');
    context.pop();
  }

  Future<void> _pickDate() async {
    final now = today();
    final date = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(now.year - 5),
      lastDate: now, // A workout cannot be logged in the future.
    );
    if (date != null) setState(() => _day = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _startMinutes ~/ 60,
        minute: _startMinutes % 60,
      ),
    );
    if (time != null) {
      setState(() => _startMinutes = time.hour * 60 + time.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = _mode == LogMode.edit;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout log'),
        actions: [
          if (_found)
            IconButton(
              tooltip: editing ? 'Delete workout' : 'Discard draft',
              icon: const Icon(Icons.delete_outline),
              onPressed: _discardOrDelete,
            ),
        ],
      ),
      body: _found
          ? _form(context)
          : const Center(
              child: StatusView(
                icon: Icons.search_off,
                title: 'Workout not found',
                message: 'It may have been deleted.',
              ),
            ),
    );
  }

  Widget _form(BuildContext context) {
    final theme = Theme.of(context);
    final daysAgo = today().difference(_day).inDays;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_restoredDraft)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Continuing your saved draft.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        if (_mode != LogMode.edit) ...[
          SegmentedButton<LogMode>(
            segments: const [
              ButtonSegment(value: LogMode.live, label: Text('Live session')),
              ButtonSegment(value: LogMode.past, label: Text('Past workout')),
            ],
            selected: {_mode},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _mode = s.first),
          ),
          const SizedBox(height: 16),
        ],
        TextField(
          key: const Key('workout-title'),
          controller: _title,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Workout title',
            hintText: 'Full-body workout',
          ),
        ),
        const SizedBox(height: 12),
        SegmentedButton<WorkoutType>(
          segments: const [
            ButtonSegment(
              value: WorkoutType.strength,
              label: Text('Exercises and sets'),
            ),
            ButtonSegment(
              value: WorkoutType.timed,
              label: Text('Timed activity'),
            ),
          ],
          selected: {_type},
          showSelectedIcon: false,
          onSelectionChanged: (s) => _relayout(() => _type = s.first),
        ),
        const SizedBox(height: 16),
        if (_mode == LogMode.live) ...[
          Text(
            'Today | ${formatClock(_elapsed)} elapsed',
            key: const Key('workout-elapsed'),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SecondaryButton(
            icon: _running ? Icons.pause : Icons.play_arrow,
            label: _running ? 'Pause' : 'Resume',
            onPressed: () => setState(() => _running = !_running),
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  icon: Icons.calendar_today_outlined,
                  label: dayLabel(daysAgo),
                  onPressed: _pickDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SecondaryButton(
                  icon: Icons.schedule,
                  label: formatMinutes(_startMinutes),
                  onPressed: _pickTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: ValueKey('duration-$_layoutVersion'),
            initialValue: _minutes == 0 ? '' : '$_minutes',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            decoration: InputDecoration(
              labelText: _type == WorkoutType.timed
                  ? 'Duration (minutes)'
                  : 'Duration (minutes, optional)',
            ),
            onChanged: (v) => _minutes = int.tryParse(v) ?? 0,
          ),
        ],
        if (_type == WorkoutType.strength) ...[
          const SectionTitle('Exercises'),
          for (var i = 0; i < _exercises.length; i++)
            _ExerciseEditor(
              key: ValueKey('exercise-$i-$_layoutVersion'),
              exercise: _exercises[i],
              onRemove: () => _relayout(() => _exercises.removeAt(i)),
              onAddSet: () => _relayout(() {
                final last = _exercises[i].sets.last;
                _exercises[i].sets.add(_SetRow(last.reps, last.kg, false));
              }),
              onRemoveSet: (s) =>
                  _relayout(() => _exercises[i].sets.removeAt(s)),
              onChanged: () => setState(() {}),
            ),
          SecondaryButton(
            key: const Key('add-exercise'),
            icon: Icons.add,
            label: 'Add exercise',
            onPressed: _addExercise,
          ),
        ],
        const SizedBox(height: 20),
        PrimaryButton(
          key: const Key('save-workout'),
          label: _mode == LogMode.edit ? 'Save changes' : 'Finish and save',
          onPressed: _save,
        ),
        const SizedBox(height: 12),
        Text(
          _mode == LogMode.edit
              ? 'Changes update your charts and weekly totals.'
              : 'Leaving this screen keeps your draft.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// One exercise with its rows of sets: Set | Reps | kg | Done | remove.
/// Flex values instead of pixel widths, so it fits narrow phones.
class _ExerciseEditor extends StatelessWidget {
  const _ExerciseEditor({
    super.key,
    required this.exercise,
    required this.onRemove,
    required this.onAddSet,
    required this.onRemoveSet,
    required this.onChanged,
  });

  final _ExerciseRows exercise;
  final VoidCallback onRemove;
  final VoidCallback onAddSet;
  final void Function(int set) onRemoveSet;
  final VoidCallback onChanged;

  static String _weightText(double? kg) {
    if (kg == null) return '';
    return kg == kg.roundToDouble() ? '${kg.round()}' : '$kg';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canRemove = exercise.sets.length > 1;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 4, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exercise.name,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Remove exercise',
                  icon: const Icon(Icons.close),
                  onPressed: onRemove,
                ),
              ],
            ),
            DefaultTextStyle.merge(
              style: theme.textTheme.labelMedium,
              child: const Row(
                children: [
                  Expanded(child: Text('Set')),
                  Expanded(flex: 3, child: Text('Reps')),
                  SizedBox(width: 8),
                  Expanded(flex: 3, child: Text('kg (optional)')),
                  Expanded(
                    flex: 2,
                    child: Text('Done', textAlign: TextAlign.center),
                  ),
                  Spacer(flex: 2), // above the remove buttons
                ],
              ),
            ),
            const SizedBox(height: 4),
            for (var s = 0; s < exercise.sets.length; s++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(child: Text('${s + 1}')),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: exercise.sets[s].reps == 0
                            ? ''
                            : '${exercise.sets[s].reps}',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: const InputDecoration(isDense: true),
                        onChanged: (v) =>
                            exercise.sets[s].reps = int.tryParse(v) ?? 0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: _weightText(exercise.sets[s].kg),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: const InputDecoration(isDense: true),
                        onChanged: (v) => exercise.sets[s].kg = double.tryParse(
                          v.replaceAll(',', '.'),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: exercise.sets[s].done,
                          onChanged: (v) {
                            exercise.sets[s].done = v ?? false;
                            onChanged();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: IconButton(
                          tooltip: 'Remove set',
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: canRemove ? () => onRemoveSet(s) : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add set'),
              onPressed: onAddSet,
            ),
          ],
        ),
      ),
    );
  }
}
