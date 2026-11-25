# Fitness and Habit Tracker

A Flutter mobile application designed to help users build healthy routines by tracking workouts, daily habits, step goals, and progress over time.

The app brings the user's main fitness activities together in one place: log a workout, review activity history, maintain daily habits, and monitor progress through weekly and monthly summaries.

> **Health disclaimer:** This application is intended for general fitness and habit tracking only. It does not provide medical advice, diagnosis, or treatment. Users should choose activities appropriate for their abilities and consult a qualified professional when they need health guidance.

## Team Members

- Rafia Naeem
- Kabeer Khan
- Muzaffar

## Main Features

- **Account access:** Sign-in and account-related screens.
- **Home dashboard:** At-a-glance view of daily steps, habits, workout activity, and weekly summary.
- **Workout tracking:** Start a workout or record a past workout.
- **Workout history:** Review previously recorded workouts.
- **Exercise catalogue:** Browse and search exercises.
- **Exercise details:** View information about a selected exercise.
- **Habit tracking:** Add habits and mark daily habits as complete.
- **Progress tracking:** Review workout and habit progress over weekly and monthly periods.
- **Profile and settings:** Manage profile details, goals, reminders, theme, and preferences.
- **Weekly summary:** Review a summary of activity and consistency.

## Technology and Planned Integrations

| Technology / Package | Purpose |
|---|---|
| Flutter | Cross-platform mobile application UI |
| Dart | Application programming language |
| wger REST API | Exercise catalogue and exercise information |
| Device activity / step sensor | Step-count tracking, subject to device support and permission |
| Notifications | Daily goal and habit reminders |
| Local database (planned) | Store workout logs, habits, and user preferences |
| Firebase Authentication (planned) | Account authentication and sign-in |

> Integrations marked as **planned** are feature-map targets and should not be considered complete until they are connected and tested in the app.

## Screens

The following section places each current app screenshot beside its corresponding original hand-drawn notebook sketch. Some notebook photographs contain multiple screen designs and are reused where appropriate.

### 1. Account Access

| App screenshot | Original sketch |
|---|---|
| <img src="assets/1.png" alt="Account access app screenshot" width="260"> | <img src="assets/screen1.jpeg" alt="Hand-drawn account access sketch" width="260"> |

### 2. Home Dashboard

| App screenshot | Original sketch |
|---|---|
| <img src="assets/2.jpeg" alt="Home dashboard app screenshot" width="260"> | <img src="assets/screen2.jpeg" alt="Hand-drawn home dashboard sketch" width="260"> |

### 3. Workouts and History

| App screenshot | Original sketch |
|---|---|
| <img src="assets/3.jpeg" alt="Workouts and history app screenshot" width="260"> | <img src="assets/screen3.jpeg" alt="Hand-drawn workouts and history sketch" width="260"> |

### 4. Workout Log

| App screenshot | Original sketch |
|---|---|
| <img src="assets/4.jpeg" alt="Workout log app screenshot" width="260"> | <img src="assets/screen4.jpeg" alt="Hand-drawn workout log sketch" width="260"> |

### 5. Exercise Catalogue

| App screenshot | Original sketch |
|---|---|
| <img src="assets/5.png" alt="Exercise catalogue app screenshot" width="260"> | <img src="assets/screen 6 and 7.jpeg" alt="Hand-drawn exercise catalogue and exercise details sketches" width="260"> |

### 6. Exercise Details

| App screenshot | Original sketch |
|---|---|
| <img src="assets/6.png" alt="Exercise details app screenshot" width="260"> | <img src="assets/screen5.jpeg" alt="Hand-drawn exercise details and habits sketches" width="260"> |

### 7. Habits

| App screenshot | Original sketch |
|---|---|
| <img src="assets/7.jpeg" alt="Habits app screenshot" width="260"> | <img src="assets/screen5.jpeg" alt="Hand-drawn exercise details and habits sketches" width="260"> |

### 8. Habit Editor

| App screenshot | Original sketch |
|---|---|
| <img src="assets/8.png" alt="Habit editor app screenshot" width="260"> | <img src="assets/screen8 and 9.jpeg" alt="Hand-drawn habit editor and steps and goal sketches" width="260"> |

### 9. Steps and Goal

| App screenshot | Original sketch |
|---|---|
| <img src="assets/9.png" alt="Steps and goal app screenshot" width="260"> | <img src="assets/screen8 and 9.jpeg" alt="Hand-drawn habit editor and steps and goal sketches" width="260"> |

### 10. Progress

| App screenshot | Original sketch |
|---|---|
| <img src="assets/10.jpeg" alt="Progress app screenshot" width="260"> | <img src="assets/screen11.jpeg" alt="Hand-drawn progress screen sketch" width="260"> |

### 11. Weekly Summary

| App screenshot | Original sketch |
|---|---|
| <img src="assets/11.png" alt="Weekly summary app screenshot" width="260"> | <img src="assets/screen12.jpeg" alt="Hand-drawn weekly summary sketch" width="260"> |

### 12. Profile and Settings

| App screenshot | Original sketch |
|---|---|
| <img src="assets/12.jpeg" alt="Profile and settings app screenshot" width="260"> | <img src="assets/screen10.jpeg" alt="Hand-drawn settings and profile sketch" width="260"> |

### 13. Theme Selection

| App screenshot | Original sketch |
|---|---|
| <img src="assets/theme.jpeg" alt="Theme selection app screenshot" width="260"> | No separate hand-drawn notebook sketch for theme selection was included in the uploaded assets. |

## Feature Map

The feature map identifies which future integration belongs to each screen and the planned implementation stage.

| Screen | Feature that plugs in | When |
|---|---|---|
| Account Access | Firebase Authentication, Google Sign-In, account validation, password-reset flow | Next week |
| Home Dashboard | Step-count sensor, daily goal progress, dashboard data, weekly summary data | Hardware session / database integration |
| Workouts and History | Local database for workout records; retrieve and display saved workout history | Already learned — wire into the screen |
| Workout Log | Save workout date, duration, exercises, sets, and activity details to the local database | Database integration session |
| Exercise Catalogue | wger REST API for exercise search, catalogue data, and filtering | REST API session |
| Exercise Details | wger REST API for selected exercise information and instructions | REST API session |
| Habits | Save habit records and completion status; daily reminder notifications | Database and notifications session |
| Progress | Read workout and habit records and display weekly/monthly progress charts | Database and charts integration |
| Profile and Settings | Save profile details, step goal, workout target, reminder settings, and theme preferences | Local storage / database session |
| Weekly Summary | Calculate weekly workout totals, habit completion, step progress, and streak information | Database and charts integration |
| Activity Permission | Request activity-recognition permission and show a graceful explanation/fallback if permission is denied | Hardware session |

### Feature Map Notes

- The wger API is intended for exercise catalogue and exercise-detail information.
- Step tracking depends on device hardware, operating-system support, and user permission.
- If activity permission is denied, the app should remain usable and explain that automatic step tracking is unavailable.
- Notifications are intended for reminders and daily goals; users should be able to control reminder preferences.
- The app should not make medical claims or present tracked values as medical measurements.

## Project Setup

### Prerequisites

- Flutter SDK installed
- Dart SDK (included with Flutter)
- Android Studio or Visual Studio Code
- An Android emulator or a physical Android device

### Run the Application

1. Clone or download this repository.
2. Open the project folder in Visual Studio Code or Android Studio.
3. Open a terminal in the project directory.
4. Fetch the Flutter dependencies:

   ```bash
   flutter pub get
   ```

5. Check that a device or emulator is available:

   ```bash
   flutter devices
   ```

6. Run the application:

   ```bash
   flutter run
   ```

## Suggested Project Structure

The exact folder structure may vary as the project develops. A typical Flutter structure is:

```text
fitness_habit_tracker/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── screens/
│   ├── widgets/
│   ├── models/
│   └── services/
├── assets/
├── test/
├── pubspec.yaml
└── README.md
```

## Permissions and Privacy

- Request activity or step-count permission only when the related feature is introduced.
- Explain why the permission is needed before or during the permission request.
- Handle denied permissions gracefully; core workout and habit screens should remain accessible.
- Store only the information required for the app's features.
- Allow users to manage reminder preferences.

## Current Scope

The current project focuses on the app screens, visual design, and navigation between screens. Some integrations in the feature map are planned for later development sessions. Their presence in this README describes the intended implementation, not a claim that every integration is already complete.

## Future Improvements

- Complete authentication and account recovery.
- Connect the exercise catalogue to the wger REST API.
- Persist workout and habit records.
- Integrate device step counting with permission handling.
- Add configurable daily reminders.
- Add progress charts and weekly summaries.
- Test navigation, empty states, error states, and permission-denied behavior.

---

**Project:** Fitness and Habit Tracker  
**Course:** Mobile Application Development (CS 442)  
**Semester:** Fall 2026
