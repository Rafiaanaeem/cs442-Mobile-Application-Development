/// Every route of the app, in one file. One GoRoute per screen.
///
///   go to a screen:   context.push('/steps');
///   go back:          context.pop();
///   switch tab:       context.go('/habits');
library;

import 'package:go_router/go_router.dart';

import '../presentation/screens/exercise_catalogue_screen.dart';
import '../presentation/screens/exercise_detail_screen.dart';
import '../presentation/screens/habit_editor_screen.dart';
import '../presentation/screens/habits_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/progress_screen.dart';
import '../presentation/screens/result_screen.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/screens/steps_screen.dart';
import '../presentation/screens/weekly_summary_screen.dart';
import '../presentation/screens/welcome_screen.dart';
import '../presentation/screens/workout_history_screen.dart';
import '../presentation/screens/workout_log_screen.dart';
import '../presentation/widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Welcome and S01 Account access.
    GoRoute(path: '/', builder: (c, s) => const WelcomeScreen()),
    GoRoute(
      path: '/login',
      builder: (c, s) =>
          LoginScreen(createAccount: s.uri.queryParameters['mode'] == 'create'),
    ),

    // The four tabs with the bottom NavigationBar.
    StatefulShellRoute.indexedStack(
      builder: (c, s, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/workouts',
              builder: (c, s) => const WorkoutHistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/habits', builder: (c, s) => const HabitsScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              builder: (c, s) => const ProgressScreen(),
            ),
          ],
        ),
      ],
    ),

    // Screens opened on top of the tabs.
    GoRoute(
      // ?mode=live | past for a new workout, ?id=w1 to edit a saved one,
      // ?add=e7 to start with that exercise.
      path: '/workouts/log',
      builder: (c, s) => WorkoutLogScreen(
        mode: s.uri.queryParameters['mode'],
        workoutId: s.uri.queryParameters['id'],
        addExerciseId: s.uri.queryParameters['add'],
      ),
    ),
    GoRoute(
      // ?pick=true when the workout log is waiting for an exercise.
      path: '/exercises',
      builder: (c, s) => ExerciseCatalogueScreen(
        picking: s.uri.queryParameters['pick'] == 'true',
      ),
    ),
    GoRoute(
      path: '/exercises/:id',
      builder: (c, s) =>
          ExerciseDetailScreen(exerciseId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/habits/edit',
      builder: (c, s) =>
          HabitEditorScreen(habitId: s.uri.queryParameters['id']),
    ),
    GoRoute(path: '/steps', builder: (c, s) => const StepsScreen()),
    GoRoute(path: '/summary', builder: (c, s) => const WeeklySummaryScreen()),
    GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),

    // Success, empty and error screens.
    GoRoute(
      path: '/result/:kind',
      builder: (c, s) => ResultScreen(
        kind: ResultKind.fromName(s.pathParameters['kind']!),
        title: s.uri.queryParameters['title'],
        message: s.uri.queryParameters['message'],
        next: s.uri.queryParameters['next'],
      ),
    ),
  ],
);
