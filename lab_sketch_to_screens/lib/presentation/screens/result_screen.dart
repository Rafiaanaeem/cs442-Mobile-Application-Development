/// Success, empty and error screens (template: centred column).
/// Big icon, message, one button.
library;

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../widgets/status_view.dart';

enum ResultKind {
  success(
    Icons.check_circle,
    'All saved',
    'Your changes are saved.',
    'Back to Home',
  ),
  empty(
    Icons.inbox_outlined,
    'Nothing here yet',
    'No workouts match this filter. Log one and it will appear here.',
    'Go back',
  ),
  error(
    Icons.cloud_off_outlined,
    'Something went wrong',
    'Could not load exercises. Check your connection and try again.',
    'Try again',
  );

  const ResultKind(this.icon, this.title, this.message, this.button);

  final IconData icon;
  final String title;
  final String message;
  final String button;

  static ResultKind fromName(String name) =>
      values.firstWhere((k) => k.name == name, orElse: () => error);
}

/// Builds a link such as /result/success?title=Workout%20saved.
String resultLocation(
  ResultKind kind, {
  String? title,
  String? message,
  String? next,
}) => Uri(
  path: '/result/${kind.name}',
  queryParameters: {
    // ?value adds the entry only when the value is not null.
    'title': ?title,
    'message': ?message,
    'next': ?next,
  },
).toString();

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.kind,
    this.title,
    this.message,
    this.next,
  });

  final ResultKind kind;
  final String? title;
  final String? message;

  /// Where the button goes. Null goes back, or Home if there is no back.
  final String? next;

  void _continue(BuildContext context) {
    if (next != null) {
      context.go(next!);
    } else if (kind != ResultKind.success && context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (kind) {
      ResultKind.success => scheme.primary,
      ResultKind.empty => scheme.outline,
      ResultKind.error => scheme.error,
    };
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: StatusView(
              icon: kind.icon,
              color: color,
              title: title ?? kind.title,
              message: message ?? kind.message,
              actionLabel: next == '/workouts'
                  ? 'Back to workouts'
                  : kind.button,
              onAction: () => _continue(context),
            ),
          ),
        ),
      ),
    );
  }
}
