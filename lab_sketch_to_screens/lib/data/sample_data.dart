/// Fake, hard-coded data for the lab.
///
/// Nothing here is saved. In later labs Firebase (profile, workouts, habits),
/// the step sensor (steps) and the wger REST API (exercises) replace these
/// lists, and the screens stay the same.
library;

import 'package:material_ui/material_ui.dart';

import '../app/format.dart';

// =================================================================== profile

class SampleProfile {
  const SampleProfile({
    required this.name,
    required this.email,
    required this.stepGoal,
    required this.weeklyWorkoutTarget,
    required this.dailyReminder,
    required this.reminderMinutes,
  });

  final String name;
  final String email;
  final int stepGoal;
  final int weeklyWorkoutTarget;
  final bool dailyReminder;

  /// Minutes after midnight, 19 * 60 = 19:00.
  final int reminderMinutes;
}

const sampleProfile = SampleProfile(
  name: 'Sara Ahmed',
  email: 'sara@example.com',
  stepGoal: 8000,
  weeklyWorkoutTarget: 3,
  dailyReminder: true,
  reminderMinutes: 19 * 60,
);

const disclaimer =
    'For fitness tracking and motivation only. '
    'This app does not provide medical advice.';

// ================================================================= exercises

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.equipment,
    required this.muscles,
    required this.description,
  });

  final String id;
  final String name;
  final String category;
  final List<String> equipment;
  final List<String> muscles;
  final String description;

  String get subtitle => '$category | ${equipment.join(', ')}';

  IconData get icon => categoryIcons[category] ?? Icons.fitness_center;
}

const exerciseCategories = [
  'Chest',
  'Back',
  'Legs',
  'Shoulders',
  'Arms',
  'Abs',
  'Cardio',
];

const exerciseEquipment = [
  'Barbell',
  'Dumbbell',
  'Kettlebell',
  'Bench',
  'Machine',
  'Pull-up bar',
  'Jump rope',
  'Bodyweight',
];

const categoryIcons = <String, IconData>{
  'Chest': Icons.fitness_center,
  'Back': Icons.rowing,
  'Legs': Icons.directions_walk,
  'Shoulders': Icons.accessibility_new,
  'Arms': Icons.sports_gymnastics,
  'Abs': Icons.self_improvement,
  'Cardio': Icons.directions_run,
};

const sampleExercises = <Exercise>[
  Exercise(
    id: 'e1',
    name: 'Bench press',
    category: 'Chest',
    equipment: ['Barbell', 'Bench'],
    muscles: ['Chest', 'Triceps', 'Front shoulders'],
    description:
        'Lie on a flat bench with your feet on the floor. Lower the '
        'bar to the middle of your chest, then press it up until your arms '
        'are straight.',
  ),
  Exercise(
    id: 'e2',
    name: 'Push-up',
    category: 'Chest',
    equipment: ['Bodyweight'],
    muscles: ['Chest', 'Triceps', 'Core'],
    description:
        'Start in a high plank with your hands under your shoulders. '
        'Keep your body straight, lower your chest towards the floor, then '
        'push back up.',
  ),
  Exercise(
    id: 'e3',
    name: 'Dumbbell fly',
    category: 'Chest',
    equipment: ['Dumbbell', 'Bench'],
    muscles: ['Chest'],
    description:
        'Lie on a bench with the dumbbells above your chest. Open '
        'your arms in a wide arc with soft elbows, then bring them back '
        'together.',
  ),
  Exercise(
    id: 'e4',
    name: 'Pull-up',
    category: 'Back',
    equipment: ['Pull-up bar'],
    muscles: ['Lats', 'Biceps'],
    description:
        'Hang from the bar with an overhand grip. Pull until your '
        'chin is over the bar, then lower yourself slowly.',
  ),
  Exercise(
    id: 'e5',
    name: 'Bent-over row',
    category: 'Back',
    equipment: ['Barbell'],
    muscles: ['Lats', 'Upper back', 'Biceps'],
    description:
        'Hinge at the hips with a flat back. Pull the bar to your '
        'lower ribs, squeeze your shoulder blades, then lower it.',
  ),
  Exercise(
    id: 'e6',
    name: 'Lat pulldown',
    category: 'Back',
    equipment: ['Machine'],
    muscles: ['Lats', 'Biceps'],
    description:
        'Sit with your thighs under the pads. Pull the bar down to '
        'your upper chest, then let it rise with control.',
  ),
  Exercise(
    id: 'e7',
    name: 'Squat',
    category: 'Legs',
    equipment: ['Barbell'],
    muscles: ['Quadriceps', 'Glutes', 'Hamstrings'],
    description:
        'Stand with feet shoulder-width apart and the bar on your '
        'upper back. Sit down and back until your thighs are level with the '
        'floor, then stand up.',
  ),
  Exercise(
    id: 'e8',
    name: 'Lunge',
    category: 'Legs',
    equipment: ['Bodyweight', 'Dumbbell'],
    muscles: ['Quadriceps', 'Glutes'],
    description:
        'Step forward and lower your back knee towards the floor. '
        'Push through the front heel to return, then switch legs.',
  ),
  Exercise(
    id: 'e9',
    name: 'Deadlift',
    category: 'Legs',
    equipment: ['Barbell'],
    muscles: ['Hamstrings', 'Glutes', 'Lower back'],
    description:
        'Stand with the bar over your mid-foot. Keep your back flat, '
        'push the floor away and stand tall, then lower the bar the same way.',
  ),
  Exercise(
    id: 'e10',
    name: 'Calf raise',
    category: 'Legs',
    equipment: ['Bodyweight'],
    muscles: ['Calves'],
    description:
        'Stand on the edge of a step. Rise onto your toes, pause, '
        'then lower your heels below the step.',
  ),
  Exercise(
    id: 'e11',
    name: 'Shoulder press',
    category: 'Shoulders',
    equipment: ['Dumbbell'],
    muscles: ['Shoulders', 'Triceps'],
    description:
        'Hold the dumbbells at shoulder height. Press them overhead '
        'until your arms are straight, then lower them.',
  ),
  Exercise(
    id: 'e12',
    name: 'Lateral raise',
    category: 'Shoulders',
    equipment: ['Dumbbell'],
    muscles: ['Side shoulders'],
    description:
        'Hold light dumbbells at your sides. Raise your arms out to '
        'shoulder height with a slight bend in the elbows, then lower them.',
  ),
  Exercise(
    id: 'e13',
    name: 'Bicep curl',
    category: 'Arms',
    equipment: ['Dumbbell'],
    muscles: ['Biceps'],
    description:
        'Keep your elbows by your sides. Curl the dumbbells up to '
        'your shoulders, then lower them slowly.',
  ),
  Exercise(
    id: 'e14',
    name: 'Triceps dip',
    category: 'Arms',
    equipment: ['Bench', 'Bodyweight'],
    muscles: ['Triceps'],
    description:
        'Put your hands on the edge of a bench behind you. Bend your '
        'elbows to lower your body, then press back up.',
  ),
  Exercise(
    id: 'e15',
    name: 'Plank',
    category: 'Abs',
    equipment: ['Bodyweight'],
    muscles: ['Core', 'Shoulders'],
    description:
        'Rest on your forearms and toes with your body in a straight '
        'line. Hold the position and keep breathing.',
  ),
  Exercise(
    id: 'e16',
    name: 'Russian twist',
    category: 'Abs',
    equipment: ['Bodyweight'],
    muscles: ['Obliques', 'Core'],
    description:
        'Sit with your knees bent and lean back a little. Turn your '
        'chest from side to side, touching the floor beside your hips.',
  ),
  Exercise(
    id: 'e17',
    name: 'Kettlebell swing',
    category: 'Cardio',
    equipment: ['Kettlebell'],
    muscles: ['Glutes', 'Hamstrings', 'Core'],
    description:
        'Hinge at the hips and swing the kettlebell between your '
        'legs. Drive your hips forward to swing it to chest height.',
  ),
  Exercise(
    id: 'e18',
    name: 'Jumping jacks',
    category: 'Cardio',
    equipment: ['Bodyweight'],
    muscles: ['Full body'],
    description:
        'Jump your feet out while raising your arms overhead, then '
        'jump back to the start. Keep a steady rhythm.',
  ),
  Exercise(
    id: 'e19',
    name: 'Jump rope',
    category: 'Cardio',
    equipment: ['Jump rope'],
    muscles: ['Calves', 'Shoulders'],
    description:
        'Turn the rope with your wrists and jump just high enough '
        'for it to pass under your feet.',
  ),
  Exercise(
    id: 'e20',
    name: 'Burpee',
    category: 'Cardio',
    equipment: ['Bodyweight'],
    muscles: ['Full body'],
    description:
        'Squat, place your hands down and jump your feet back into a '
        'plank. Jump your feet in again and leap up with your arms overhead.',
  ),
];

Exercise? exerciseById(String id) {
  for (final e in sampleExercises) {
    if (e.id == id) return e;
  }
  return null;
}

// ================================================================== workouts

enum WorkoutType { strength, timed }

/// One row in an exercise: reps, optional weight, and whether it was done.
class ExerciseSet {
  const ExerciseSet(this.reps, [this.kg, this.done = true]);

  final int reps;

  /// Null for bodyweight exercises.
  final double? kg;
  final bool done;
}

class WorkoutExercise {
  const WorkoutExercise(this.exerciseId, this.sets);

  final String exerciseId;
  final List<ExerciseSet> sets;

  String get name => exerciseById(exerciseId)?.name ?? exerciseId;
}

class Workout {
  const Workout({
    required this.id,
    required this.title,
    required this.daysAgo,
    required this.startMinutes,
    required this.minutes,
    this.type = WorkoutType.strength,
    this.exercises = const [],
    this.pendingSync = false,
  });

  final String id;
  final String title;
  final int daysAgo;

  /// Start time, minutes after midnight.
  final int startMinutes;
  final int minutes;
  final WorkoutType type;
  final List<WorkoutExercise> exercises;

  /// Saved on the phone but not yet uploaded (shown for the Firebase lab).
  final bool pendingSync;

  String get description => [
    dayLabel(daysAgo),
    if (minutes > 0) '$minutes min',
    type == WorkoutType.timed
        ? 'Timed activity'
        : plural(exercises.length, 'exercise'),
    if (pendingSync) 'Pending sync',
  ].join(' | ');
}

const sampleWorkouts = <Workout>[
  Workout(
    id: 'w1',
    title: 'Push day',
    daysAgo: 0,
    startMinutes: 7 * 60 + 15,
    minutes: 52,
    pendingSync: true,
    exercises: [
      WorkoutExercise('e1', [
        ExerciseSet(10, 40),
        ExerciseSet(8, 45),
        ExerciseSet(8, 45),
      ]),
      WorkoutExercise('e11', [ExerciseSet(10, 12), ExerciseSet(10, 12)]),
      WorkoutExercise('e14', [ExerciseSet(12), ExerciseSet(10)]),
    ],
  ),
  Workout(
    id: 'w2',
    title: 'Evening run',
    daysAgo: 1,
    startMinutes: 18 * 60 + 30,
    minutes: 30,
    type: WorkoutType.timed,
  ),
  Workout(
    id: 'w3',
    title: 'Leg day',
    daysAgo: 2,
    startMinutes: 17 * 60,
    minutes: 60,
    exercises: [
      WorkoutExercise('e7', [
        ExerciseSet(8, 60),
        ExerciseSet(8, 60),
        ExerciseSet(6, 65),
        ExerciseSet(6, 65, false),
      ]),
      WorkoutExercise('e8', [ExerciseSet(12, 10), ExerciseSet(12, 10)]),
      WorkoutExercise('e10', [ExerciseSet(20), ExerciseSet(20)]),
    ],
  ),
  Workout(
    id: 'w4',
    title: 'Pull day',
    daysAgo: 4,
    startMinutes: 17 * 60 + 45,
    minutes: 48,
    exercises: [
      WorkoutExercise('e4', [ExerciseSet(6), ExerciseSet(6), ExerciseSet(5)]),
      WorkoutExercise('e5', [ExerciseSet(10, 40), ExerciseSet(10, 40)]),
      WorkoutExercise('e13', [ExerciseSet(12, 10), ExerciseSet(10, 10)]),
    ],
  ),
  Workout(
    id: 'w5',
    title: 'Core and cardio',
    daysAgo: 6,
    startMinutes: 8 * 60,
    minutes: 25,
    exercises: [
      WorkoutExercise('e15', [ExerciseSet(60), ExerciseSet(45)]),
      WorkoutExercise('e16', [ExerciseSet(20), ExerciseSet(20)]),
      WorkoutExercise('e20', [ExerciseSet(10), ExerciseSet(10)]),
    ],
  ),
  Workout(
    id: 'w6',
    title: 'Cycling',
    daysAgo: 8,
    startMinutes: 16 * 60,
    minutes: 45,
    type: WorkoutType.timed,
  ),
  Workout(
    id: 'w7',
    title: 'Full body',
    daysAgo: 9,
    startMinutes: 18 * 60,
    minutes: 55,
    exercises: [
      WorkoutExercise('e9', [ExerciseSet(5, 80), ExerciseSet(5, 80)]),
      WorkoutExercise('e2', [ExerciseSet(15), ExerciseSet(12)]),
      WorkoutExercise('e17', [ExerciseSet(15, 16), ExerciseSet(15, 16)]),
    ],
  ),
  Workout(
    id: 'w8',
    title: 'Upper body',
    daysAgo: 12,
    startMinutes: 7 * 60,
    minutes: 40,
    exercises: [
      WorkoutExercise('e6', [ExerciseSet(12, 35), ExerciseSet(10, 40)]),
      WorkoutExercise('e12', [ExerciseSet(15, 6), ExerciseSet(12, 6)]),
    ],
  ),
  Workout(
    id: 'w9',
    title: 'Morning walk',
    daysAgo: 15,
    startMinutes: 6 * 60 + 30,
    minutes: 35,
    type: WorkoutType.timed,
  ),
  Workout(
    id: 'w10',
    title: 'Leg day',
    daysAgo: 19,
    startMinutes: 17 * 60,
    minutes: 50,
    exercises: [
      WorkoutExercise('e7', [ExerciseSet(8, 55), ExerciseSet(8, 55)]),
      WorkoutExercise('e9', [ExerciseSet(5, 75)]),
    ],
  ),
];

Workout? workoutById(String id) {
  for (final w in sampleWorkouts) {
    if (w.id == id) return w;
  }
  return null;
}

/// The unsaved live session shown when "Start workout" is pressed.
const sampleDraft = Workout(
  id: 'draft',
  title: 'Upper body',
  daysAgo: 0,
  startMinutes: 0,
  minutes: 0,
  exercises: [
    WorkoutExercise('e2', [ExerciseSet(15), ExerciseSet(12, null, false)]),
  ],
);

/// How long the sample live session has been running when it opens.
const sampleDraftElapsedSeconds = 12 * 60 + 34;

// ==================================================================== habits

class Habit {
  const Habit({
    required this.id,
    required this.name,
    required this.weekdays,
    required this.streak,
    this.reminderMinutes,
  });

  final String id;
  final String name;

  /// 1 = Monday ... 7 = Sunday, like DateTime.weekday.
  final Set<int> weekdays;

  /// Days in a row the habit was done.
  final int streak;

  /// Reminder time in minutes after midnight, or null for no reminder.
  final int? reminderMinutes;

  bool isScheduledOn(DateTime day) => weekdays.contains(day.weekday);
}

const sampleHabits = <Habit>[
  Habit(
    id: 'h1',
    name: 'Drink water with every meal',
    weekdays: {1, 2, 3, 4, 5, 6, 7},
    streak: 12,
  ),
  Habit(
    id: 'h2',
    name: 'Stretch for 10 minutes',
    weekdays: {1, 2, 3, 4, 5, 6, 7},
    streak: 5,
    reminderMinutes: 7 * 60 + 30,
  ),
  Habit(id: 'h3', name: 'Walk outside', weekdays: {1, 2, 3, 4, 5}, streak: 3),
  Habit(
    id: 'h4',
    name: 'Strength session',
    weekdays: {1, 3, 5},
    streak: 4,
    reminderMinutes: 18 * 60,
  ),
  Habit(
    id: 'h5',
    name: 'Be in bed by 23:00',
    weekdays: {1, 2, 3, 4, 7},
    streak: 0,
    reminderMinutes: 22 * 60 + 30,
  ),
  Habit(id: 'h6', name: 'Read 10 pages', weekdays: {6, 7}, streak: 2),
];

Habit? habitById(String id) {
  for (final h in sampleHabits) {
    if (h.id == id) return h;
  }
  return null;
}

/// Ticks already made, written as "habitId@daysAgo".
const sampleCompletions = <String>{
  'h1@0',
  'h3@0',
  'h6@0',
  'h1@1',
  'h2@1',
  'h3@1',
  'h4@1',
  'h6@1',
  'h1@2',
  'h2@2',
  'h3@2',
  'h5@2',
  'h6@2',
  'h1@3',
  'h2@3',
  'h4@3',
  'h5@3',
  'h6@3',
  'h1@4',
  'h2@4',
  'h3@4',
  'h6@4',
  'h1@5',
  'h2@5',
  'h3@5',
  'h4@5',
  'h5@5',
  'h6@5',
  'h1@6',
  'h2@6',
  'h3@6',
  'h6@6',
};

/// Ready-made habits on the "Fitness template" tab of the habit editor.
const fitnessHabitTemplates = <({String name, Set<int> weekdays})>[
  (name: 'Stretch for 10 minutes', weekdays: {1, 2, 3, 4, 5, 6, 7}),
  (name: 'Walk outside', weekdays: {1, 2, 3, 4, 5, 6, 7}),
  (name: 'Drink water with every meal', weekdays: {1, 2, 3, 4, 5, 6, 7}),
  (name: 'Strength session', weekdays: {1, 3, 5}),
  (name: 'Take the stairs', weekdays: {1, 2, 3, 4, 5}),
  (name: 'Be in bed by 23:00', weekdays: {1, 2, 3, 4, 7}),
];

// ===================================================================== steps

/// Steps per day. Index 0 is today, 1 is yesterday, and so on.
/// Null means the phone did not record that day ("not tracked").
const sampleStepsByDaysAgo = <int?>[
  6300, 9120, 8480, 10450, 7480, null, 8230, 5120, 8890, 9340, //
  null, null, 7210, 8640, 11020, 6480, 8120, 9900, 4300, 8010, //
  7700, null, 8600, 5900,
];

int? stepsOn(int daysAgo) =>
    daysAgo >= 0 && daysAgo < sampleStepsByDaysAgo.length
    ? sampleStepsByDaysAgo[daysAgo]
    : null;

/// Days in a row, ending yesterday (or today once the goal is reached), on
/// which the step goal was reached.
int stepStreak() {
  var streak = (stepsOn(0) ?? 0) >= sampleProfile.stepGoal ? 1 : 0;
  for (var d = 1; (stepsOn(d) ?? 0) >= sampleProfile.stepGoal; d++) {
    streak++;
  }
  return streak;
}

// ============================================================== summaries

/// Totals for one week or month.
class PeriodSummary {
  const PeriodSummary({
    required this.workouts,
    required this.workoutTarget,
    required this.minutes,
    required this.steps,
    required this.trackedDays,
    required this.days,
    required this.goalMetDays,
    required this.habitsDone,
    required this.habitsDue,
  });

  final int workouts;
  final int workoutTarget;
  final int minutes;
  final int steps;
  final int trackedDays;

  /// Days in the period up to today.
  final int days;
  final int goalMetDays;
  final int habitsDone;
  final int habitsDue;

  int? get habitPercent =>
      habitsDue == 0 ? null : (habitsDone * 100 / habitsDue).round();

  bool get targetMet => workouts >= workoutTarget;

  bool get isEmpty => workouts == 0 && trackedDays == 0 && habitsDone == 0;
}

/// Habit ticks per week (done, due): this week so far, last week, and so on.
const _habitTotalsByWeek = [(14, 18), (31, 36), (24, 34), (10, 20)];

/// Number of weeks that have any records. The oldest has no comparison.
const sampleWeekCount = 4;

/// Totals for days [fromDaysAgo] down to [toDaysAgo], both included.
PeriodSummary _summarise(
  int fromDaysAgo,
  int toDaysAgo, {
  required int habitsDone,
  required int habitsDue,
  int? target,
}) {
  var workouts = 0, minutes = 0, steps = 0, tracked = 0, goalMet = 0;
  for (final w in sampleWorkouts) {
    if (w.daysAgo <= fromDaysAgo && w.daysAgo >= toDaysAgo) {
      workouts++;
      minutes += w.minutes;
    }
  }
  for (var d = toDaysAgo; d <= fromDaysAgo; d++) {
    final s = stepsOn(d);
    if (s == null) continue;
    tracked++;
    steps += s;
    if (s >= sampleProfile.stepGoal) goalMet++;
  }
  return PeriodSummary(
    workouts: workouts,
    workoutTarget: target ?? sampleProfile.weeklyWorkoutTarget,
    minutes: minutes,
    steps: steps,
    trackedDays: tracked,
    days: fromDaysAgo - toDaysAgo + 1,
    goalMetDays: goalMet,
    habitsDone: habitsDone,
    habitsDue: habitsDue,
  );
}

/// Monday of the week [weeksBack] weeks ago, counted in days ago.
int weekStartDaysAgo(int weeksBack) => today().weekday - 1 + 7 * weeksBack;

/// A week runs Monday to Sunday. 0 is this week so far, 1 is last week.
PeriodSummary weekSummary(int weeksBack) {
  final start = weekStartDaysAgo(weeksBack);
  final end = weeksBack == 0 ? 0 : start - 6;
  final habits = _habitTotalsByWeek[weeksBack];
  return _summarise(start, end, habitsDone: habits.$1, habitsDue: habits.$2);
}

/// This calendar month so far.
PeriodSummary monthSummary() =>
    _summarise(today().day - 1, 0, habitsDone: 102, habitsDue: 124, target: 12);
