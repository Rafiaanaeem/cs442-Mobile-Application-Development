/// S08 Habit editor (template: FORM). Create a custom habit, start from a
/// fitness template, or edit an existing habit. Reminders become phone
/// notifications in the hardware session.
library;

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../app/format.dart';
import '../../data/sample_data.dart';
import '../widgets/app_shell.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_title.dart';

class HabitEditorScreen extends StatefulWidget {
  const HabitEditorScreen({super.key, this.habitId});

  /// Null creates a new habit.
  final String? habitId;

  @override
  State<HabitEditorScreen> createState() => _HabitEditorScreenState();
}

class _HabitEditorScreenState extends State<HabitEditorScreen> {
  final _name = TextEditingController();
  var _weekdays = <int>{1, 2, 3, 4, 5, 6, 7};
  var _remind = false;
  var _reminderMinutes = 19 * 60;
  var _fromTemplate = false;
  Habit? _existing;
  String? _nameError;
  String? _daysError;

  @override
  void initState() {
    super.initState();
    final h = widget.habitId == null ? null : habitById(widget.habitId!);
    if (h != null) {
      _existing = h;
      _name.text = h.name;
      _weekdays = {...h.weekdays};
      _remind = h.reminderMinutes != null;
      _reminderMinutes = h.reminderMinutes ?? _reminderMinutes;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _useTemplate(({String name, Set<int> weekdays}) template) =>
      setState(() {
        _name.text = template.name;
        _weekdays = {...template.weekdays};
        _nameError = null;
        _daysError = null;
      });

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _reminderMinutes ~/ 60,
        minute: _reminderMinutes % 60,
      ),
    );
    if (time != null) {
      setState(() => _reminderMinutes = time.hour * 60 + time.minute);
    }
  }

  void _save() {
    setState(() {
      _nameError = _name.text.trim().isEmpty ? 'Give the habit a name' : null;
      _daysError = _weekdays.isEmpty ? 'Choose at least one day' : null;
    });
    if (_nameError != null || _daysError != null) return;
    showSnack(context, 'Habit saved');
    context.pop();
  }

  Future<void> _archive() async {
    final ok = await confirm(
      context,
      title: 'Archive habit?',
      message:
          'It leaves your list from today. Past completions are kept '
          'in your history and summaries.',
      action: 'Archive',
    );
    if (!ok || !mounted) return;
    showSnack(context, 'Habit archived');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final editing = _existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit habit' : 'Create habit')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!editing) ...[
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Custom')),
                ButtonSegment(value: true, label: Text('Fitness template')),
              ],
              selected: {_fromTemplate},
              showSelectedIcon: false,
              onSelectionChanged: (s) =>
                  setState(() => _fromTemplate = s.first),
            ),
            const SizedBox(height: 16),
          ],
          if (_fromTemplate && !editing) ...[
            Text(
              'Pick a template, then change anything you like.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final t in fitnessHabitTemplates)
                  ActionChip(
                    label: Text(t.name),
                    onPressed: () => _useTemplate(t),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          TextField(
            key: const Key('habit-name'),
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Habit name',
              hintText: 'Read 10 pages',
              errorText: _nameError,
            ),
          ),
          const SectionTitle('Repeat on'),
          Row(
            children: [
              for (var day = 1; day <= 7; day++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _DayToggle(
                      label: weekdayLetters[day - 1],
                      tooltip: weekdayShort[day - 1],
                      selected: _weekdays.contains(day),
                      onTap: () => setState(() {
                        _weekdays.contains(day)
                            ? _weekdays.remove(day)
                            : _weekdays.add(day);
                        _daysError = null;
                      }),
                    ),
                  ),
                ),
            ],
          ),
          if (_daysError != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                _daysError!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            'Completion: one check per scheduled day',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Remind me'),
            value: _remind,
            onChanged: (v) => setState(() => _remind = v ?? false),
          ),
          if (_remind)
            SecondaryButton(
              icon: Icons.schedule,
              label: 'Reminder time: ${formatMinutes(_reminderMinutes)}',
              onPressed: _pickTime,
            ),
          const SizedBox(height: 20),
          PrimaryButton(
            key: const Key('save-habit'),
            label: 'Save habit',
            onPressed: _save,
          ),
          if (editing) ...[
            const SizedBox(height: 8),
            SecondaryButton(label: 'Archive habit', onPressed: _archive),
          ],
        ],
      ),
    );
  }
}

/// A round day button. AspectRatio keeps it round at any width.
class _DayToggle extends StatelessWidget {
  const _DayToggle({
    required this.label,
    required this.tooltip,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String tooltip;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      // Grows with the screen, but not past a comfortable size on a laptop.
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 56),
          child: AspectRatio(
            aspectRatio: 1,
            child: Material(
              color: selected ? scheme.primary : scheme.surfaceContainerHighest,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
