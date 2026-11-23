import 'package:material_ui/material_ui.dart';

import 'app/router.dart';
import 'app/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Rebuilds when the theme is changed in Settings (light, dark or system).
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
    valueListenable: themeMode,
    builder: (context, mode, _) => MaterialApp.router(
      title: 'Fitness and Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      darkTheme: appDarkTheme,
      themeMode: mode,
      routerConfig: appRouter,
    ),
  );
}
