/// S01 Account access (template: FORM). Sign in or create an account.
/// Firebase Authentication plugs in here next week; today the button just
/// opens Home.
library;

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_shell.dart';
import '../widgets/disclaimer_text.dart';
import '../widgets/primary_button.dart';

String? validateEmail(String? value) {
  final email = (value ?? '').trim();
  if (email.isEmpty) return 'Enter your email';
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validatePassword(String? value) {
  if ((value ?? '').isEmpty) return 'Enter your password';
  if (value!.length < 6) return 'Use at least 6 characters';
  return null;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.createAccount = false});

  /// Opens on the "Create account" tab instead of "Sign in".
  final bool createAccount;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  late var _creating = widget.createAccount;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    // go() replaces the stack, so Back does not return to the login form.
    context.go('/home');
  }

  Future<void> _forgotPassword() async {
    final email = await showDialog<String>(
      context: context,
      builder: (context) => const _ResetPasswordDialog(),
    );
    if (email != null && mounted) {
      showSnack(context, 'If an account exists, a reset link was sent.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Fitness and Habit Tracker',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            const Text('Track effort. Build consistency.'),
            const SizedBox(height: 12),
            Text(
              'Lab build: any email and a 6-character password open the '
              'app. Nothing is sent anywhere.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Sign in')),
                ButtonSegment(value: true, label: Text('Create account')),
              ],
              selected: {_creating},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _creating = s.first),
            ),
            const SizedBox(height: 20),
            if (_creating) ...[
              TextFormField(
                key: const Key('login-name'),
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Display name'),
                validator: (v) => (v ?? '').trim().isEmpty
                    ? 'Enter a name to show in the app'
                    : null,
              ),
              const SizedBox(height: 12),
            ],
            TextFormField(
              key: const Key('login-email'),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'you@example.com',
              ),
              validator: validateEmail,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('login-password'),
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: validatePassword,
            ),
            if (_creating) ...[
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('login-confirm'),
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                ),
                validator: (v) =>
                    v != _password.text ? 'Passwords do not match' : null,
              ),
            ] else
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _forgotPassword,
                  child: const Text('Forgot password?'),
                ),
              ),
            const SizedBox(height: 12),
            PrimaryButton(
              key: const Key('login-submit'),
              label: _creating ? 'Create account' : 'Sign in',
              onPressed: _submit,
            ),
            const SizedBox(height: 24),
            const DisclaimerText(),
          ],
        ),
      ),
    );
  }
}

class _ResetPasswordDialog extends StatefulWidget {
  const _ResetPasswordDialog();

  @override
  State<_ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<_ResetPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Reset password'),
    content: Form(
      key: _formKey,
      child: TextFormField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(labelText: 'Email'),
        validator: validateEmail,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pop(context, _email.text.trim());
          }
        },
        child: const Text('Send reset link'),
      ),
    ],
  );
}
