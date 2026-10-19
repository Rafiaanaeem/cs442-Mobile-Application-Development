
import 'dart:async';

import 'package:flutter/material.dart';

// Personalized lab settings: roll number 04072313032.
const String studentName = 'Rafia Naeem';
const String rollNumber = '04072313032';
const String course = 'Operating Systems';

const int startCount = 5;
const int stepSize = 4;
const int maxCount = 26;
const int startSeconds = 10;
const int bugStep = 3;

final List<String> lifecycleLog = <String>[];

void main() {
  runApp(const LabApp());
}

// Stateless
// Provides the application and its home screen.
class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Study Tracker',
      home: HomePage(),
    );
  }
}

// Stateless
// Arranges the lab widgets in the required order.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Tracker')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StudentCard(),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Text('Course: $course')),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Roll: $rollNumber',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Tally(),
              const SizedBox(height: 16),
              const Countdown(),
              const SizedBox(height: 16),
              const BuggyCounter(),
            ],
          ),
        ),
      ),
    );
  }
}

// Stateless
// Displays the student's fixed information.
class StudentCard extends StatelessWidget {
  const StudentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(studentName),
            const Text('Roll Number: $rollNumber'),
            const Text('BS Computer Science'),
          ],
        ),
      ),
    );
  }
}

// Stateless
// Displays progress using values supplied by Tally.
class GoalBanner extends StatelessWidget {
  final int count;
  final int goal;

  const GoalBanner({
    super.key,
    required this.count,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final int percentage = count * 100 ~/ goal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Progress: $percentage%'),
        LinearProgressIndicator(
          value: (count / goal).clamp(0.0, 1.0).toDouble(),
        ),
      ],
    );
  }
}

// Stateful
// Manages the study count and responds to button taps.
class Tally extends StatefulWidget {
  const Tally({super.key});

  @override
  State<Tally> createState() => _TallyState();
}

class _TallyState extends State<Tally> {
  int _count = startCount;

  void _increase() {
    setState(() {
      _count = (_count + stepSize).clamp(0, maxCount).toInt();
    });
  }

  void _decrease() {
    setState(() {
      _count = (_count - stepSize).clamp(0, maxCount).toInt();
    });
  }

  void _reset() {
    setState(() {
      _count = startCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Study count: $_count / $maxCount'),
            const SizedBox(height: 8),
            GoalBanner(count: _count, goal: maxCount),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _increase,
                  child: const Text('Add $stepSize'),
                ),
                OutlinedButton(
                  onPressed: _decrease,
                  child: const Text('Subtract $stepSize'),
                ),
                TextButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Stateful
// Updates the countdown and counts its build calls.
class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late int _left;
  late Timer _timer;
  int _builds = 0;

  @override
  void initState() {
    super.initState();
    lifecycleLog.add('initState');
    _left = startSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_left <= 1) {
        timer.cancel();
        setState(() {
          _left = 0;
        });
      } else {
        setState(() {
          _left--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    lifecycleLog.add('dispose');
    debugPrint('Countdown lifecycle: $lifecycleLog');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _builds++;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _left > 0 ? 'Time left: $_left s' : 'Time is up!',
              key: const Key('time-left'),
            ),
            const SizedBox(height: 8),
            Text('Builds: $_builds', key: const Key('builds')),
          ],
        ),
      ),
    );
  }
}

// Stateful
// Demonstrates updating the click count using setState().
class BuggyCounter extends StatefulWidget {
  const BuggyCounter({super.key});

  @override
  State<BuggyCounter> createState() => _BuggyCounterState();
}

class _BuggyCounterState extends State<BuggyCounter> {
  int _clicks = 0;

  void _increment() {
    setState(() {
      _clicks += bugStep;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clicks: $_clicks', key: const Key('clicks')),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _increment,
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
