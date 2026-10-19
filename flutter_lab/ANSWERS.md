
# CS442 Flutter Study Tracker Lab

**Name:** Rafia Naeem  
**Roll Number:** 04072313032  
**Course:** Operating Systems

## Overview

Study Tracker is a Flutter application developed for the CS442 lab. It demonstrates Flutter widgets, state management, user interaction, countdown timers, widget lifecycle methods, and progress tracking.

## Features

- **Student Information:** Displays the student's name, roll number, and degree.
- **Study Goal:** Shows the current count and progress toward the maximum.
- **Tally Counter:** Increases, decreases, and resets the count using buttons.
- **Countdown Timer:** Updates every second and displays a message when the countdown finishes.
- **Buggy Counter Fix:** Demonstrates how `setState()` refreshes the UI when the state changes.
- **Responsive Layout:** Uses a scrollable layout to accommodate the interface.

## Seeded Settings

The values below are derived from the roll number `04072313032`, using its last two digits: `t = 3` and `u = 2`.

| Setting | Value |
|---|---:|
| Initial count | 5 |
| Step size | 4 |
| Maximum count | 26 |
| Countdown start | 10 seconds |
| Buggy counter step | 3 |
| Initial progress | 19% |

## A1–A4 Answers

The answers are provided as plain whole numbers for automatic checking.

**A1**
```text
6
```

**A2**
```text
11
```

**A3**
```text
9
```

**A4**
```text
19
```

## Technologies

- Flutter
- Dart
- Material Design widgets

## Run the Application

Make sure Flutter is installed and configured, then open a terminal in the `flutter_lab` directory.

Format the code:

```powershell
dart format lib
```

Analyze the project:

```powershell
flutter analyze
```

Run the application in Chrome:

```powershell
flutter run -d chrome
```

## Project Structure

```text
flutter_lab/
├── lib/
│   └── main.dart
├── test/
├── README.md
├── ANSWERS.md
└── screenshot.png
```

The screenshot should be captured from the actual running application after the countdown finishes.

## Concepts Demonstrated

- `StatelessWidget` and `StatefulWidget`
- `setState()` and UI rebuilding
- `initState()` and `dispose()`
- `Timer.periodic()` and timer cancellation
- Progress calculation and integer division using `~/`
- `const` constructors and widgets
- Layout widgets, buttons, and scrollable content
