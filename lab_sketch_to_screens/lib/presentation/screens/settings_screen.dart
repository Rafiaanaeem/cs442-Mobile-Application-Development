/// S12 Settings and profile (template: LIST of settings tiles plus an avatar
/// at the top). Targets, reminders, theme, permissions and the account.
library;

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../app/format.dart';
import '../../app/theme.dart';
import '../../data/sample_data.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';
import '../widgets/disclaimer_text.dart';
import '../widgets/section_title.dart';
import 'result_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _name = sampleProfile.name;
  var _target = sampleProfile.weeklyWorkoutTarget;
  var _reminder = sampleProfile.dailyReminder;
  var _reminderMinutes = sampleProfile.reminderMinutes;

  Future<void> _editName() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _NameDialog(initial: _name),
    );
    if (name != null && name.isNotEmpty) setState(() => _name = name);
  }

  Future<void> _pickTarget() async {
    final target = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Weekly workout target'),
        children: [
          for (var n = 1; n <= 7; n++)
            ListTile(
              title: Text(plural(n, 'session')),
              trailing: n == _target ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, n),
            ),
        ],
      ),
    );
    if (target != null) setState(() => _target = target);
  }

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

  Future<void> _pickTheme() async {
    final mode = await showDialog<ThemeMode>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Theme'),
        children: [
          for (final m in ThemeMode.values)
            ListTile(
              title: Text(_themeLabel(m)),
              trailing: m == themeMode.value ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, m),
            ),
        ],
      ),
    );
    if (mode != null) setState(() => themeMode.value = mode);
  }

  static String _themeLabel(ThemeMode m) => switch (m) {
    ThemeMode.system => 'Same as the phone',
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };

  Future<void> _deleteAccount() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => const _DeleteAccountDialog(),
    );
    if (ok == true && mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & profile')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Avatar at the top.
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                _name.isEmpty ? '?' : _name.trim()[0].toUpperCase(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: scheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _name,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            'Signed in as ${sampleProfile.email}',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),

          const SectionTitle('Profile and targets'),
          AppCard(
            icon: Icons.person_outline,
            title: 'Display name',
            subtitle: _name,
            onTap: _editName,
          ),
          AppCard(
            icon: Icons.flag_outlined,
            title: 'Weekly workout target',
            subtitle: plural(_target, 'session'),
            onTap: _pickTarget,
          ),
          AppCard(
            icon: Icons.directions_walk,
            title: 'Daily step goal',
            subtitle: '${formatCount(sampleProfile.stepGoal)} steps',
            onTap: () => context.push('/steps'),
          ),

          const SectionTitle('Preferences'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  key: const Key('settings-reminder'),
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('Daily reminder'),
                  subtitle: const Text(
                    'A notification to check your steps and habits',
                  ),
                  value: _reminder,
                  onChanged: (v) => setState(() => _reminder = v),
                ),
                if (_reminder)
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: const Text('Reminder time'),
                    subtitle: Text(formatMinutes(_reminderMinutes)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _pickTime,
                  ),
              ],
            ),
          ),
          AppCard(
            icon: Icons.dark_mode_outlined,
            title: 'Theme',
            subtitle: _themeLabel(themeMode.value),
            onTap: _pickTheme,
          ),
          AppCard(
            icon: Icons.calendar_month_outlined,
            title: 'Week begins',
            subtitle: 'Monday',
          ),
          AppCard(
            icon: Icons.public,
            title: 'Timezone',
            subtitle: '${DateTime.now().timeZoneName} (from this phone)',
          ),
          const AppCard(icon: Icons.straighten, title: 'Units', subtitle: 'kg'),

          const SectionTitle('Permissions and privacy'),
          AppCard(
            icon: Icons.sensors,
            title: 'Step tracking: on',
            subtitle:
                'Uses the activity permission. '
                'Refusing it never blocks workouts or habits.',
            onTap: () => context.push('/steps'),
          ),
          AppCard(
            icon: Icons.open_in_new,
            title: 'Open system settings for this app',
            onTap: () => showSnack(
              context,
              'Opens the phone settings in the hardware session.',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              'Your records are private to your account. Exercise information '
              'comes from wger (wger.de) under the CC-BY-SA licence.',
              style: theme.textTheme.bodySmall,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: DisclaimerText(),
          ),

          // Lets the instructor open every result screen from the app.
          const SectionTitle('Screen states (lab preview)'),
          AppCard(
            icon: ResultKind.success.icon,
            title: 'Success screen',
            subtitle: 'Shown after a workout is saved',
            onTap: () => context.push('/result/success'),
          ),
          AppCard(
            icon: ResultKind.empty.icon,
            title: 'Empty screen',
            subtitle: 'Shown when a list has nothing to show',
            onTap: () => context.push('/result/empty'),
          ),
          AppCard(
            icon: ResultKind.error.icon,
            title: 'Error screen',
            subtitle: 'Shown when the exercise API cannot be reached',
            onTap: () => context.push('/result/error'),
          ),

          const SizedBox(height: 8),
          const Divider(),
          TextButton(
            key: const Key('sign-out'),
            onPressed: () => context.go('/'),
            child: const Text('Sign out'),
          ),
          TextButton(
            onPressed: _deleteAccount,
            style: TextButton.styleFrom(foregroundColor: scheme.error),
            child: const Text('Delete account and data'),
          ),
        ],
      ),
    );
  }
}

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.initial});

  final String initial;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final _name = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Display name'),
    content: TextField(
      controller: _name,
      autofocus: true,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(labelText: 'Display name'),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, _name.text.trim()),
        child: const Text('Save'),
      ),
    ],
  );
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Delete account and data?'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'This permanently removes your account, workouts, habits, '
          'step history and settings. It cannot be undone.',
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _password,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Enter your password to confirm',
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancel'),
      ),
      FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
        onPressed: () {
          if (_password.text.isNotEmpty) Navigator.pop(context, true);
        },
        child: const Text('Delete everything'),
      ),
    ],
  );
}
