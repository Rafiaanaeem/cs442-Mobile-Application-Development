import 'package:material_ui/material_ui.dart';

/// The app's green, the same seed colour as the main project.
const _seed = Color(0xFF1F6F5C);

ThemeData _buildTheme(Brightness brightness) => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  // 48 is the minimum comfortable tap height, not a layout size.
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
  ),
  cardTheme: const CardThemeData(margin: EdgeInsets.symmetric(vertical: 6)),
);

final appTheme = _buildTheme(Brightness.light);

/// Stretch goal: dark theme.
final appDarkTheme = _buildTheme(Brightness.dark);

/// Which theme is used. ThemeMode.system follows the phone's setting.
/// Settings changes it; main.dart listens to it.
final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);
