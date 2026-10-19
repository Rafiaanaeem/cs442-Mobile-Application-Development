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
| Initial count (`startCount`) | 5 |
| Step size (`stepSize`) | 4 |
| Maximum count (`maxCount`) | 26 |
| Countdown start (`startSeconds`) | 10 seconds |
| Buggy counter step (`bugStep`) | 3 |
| Initial progress | 19% |

## A1–A4 Answers

**A1: how many taps of + take the tally from startCount up to maxCount**

6

**A2: how many times Countdown.build runs from the first display until Time is up! is shown**

11

**A3: value of _clicks inside BuggyCounter after 3 taps, with the bug present**

9

**A4: the percent shown in the Progress line when the app starts**

19

## B1–B3 Answers

**B1: which of your classes are Stateless and which are Stateful, and why**

**Stateless classes:** `LabApp`, `HomePage`, `StudentCard`, and `GoalBanner`. These classes do not manage their own changing state. They display fixed information or UI based on the values provided to them.

**Stateful classes:** `Tally`, `Countdown`, and `BuggyCounter`. These classes manage changing state. `Tally` updates the study count, `Countdown` updates the remaining time and build count, and `BuggyCounter` updates the click count. They use `setState()` to refresh the UI when needed.

**B2: why must the Timer be cancelled in dispose()**

The timer must be cancelled in `dispose()` to prevent it from running after the `Countdown` widget is removed. Otherwise, its callback may call `setState()` on a disposed widget, causing a Flutter error and wasting resources.

**B3: which widgets in your code can be const, and what const buys you**

Widgets with compile-time constant arguments can be declared `const`, such as `const StudentCard()`, `const SizedBox(height: 16)`, and `const Text('BS Computer Science')`.

Using `const` allows Flutter to reuse constant widget objects rather than creating new ones unnecessarily. This can reduce object creation and improve efficiency.

## Technologies

- Flutter
- Dart
- Material Design widgets

## Concepts Demonstrated

- `StatelessWidget` and `StatefulWidget`
- `setState()` and UI rebuilding
- `initState()` and `dispose()`
- `Timer.periodic()` and timer cancellation
- Progress calculation and integer division using `~/`
- `const` constructors and widgets
- Layout widgets, buttons, and scrollable content