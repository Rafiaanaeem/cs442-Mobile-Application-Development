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

// StatelessWidget: provides the app's fixed theme and home screen.
class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// StatelessWidget: arranges the lab widgets in the required order.
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

              // Course and roll information.
              const Row(
                children: [
                  Expanded(
                    child: Text('Course: Operating Systems', softWrap: true),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Roll: 04072313032',
                      textAlign: TextAlign.end,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                'Study Goal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Tally(),
              const SizedBox(height: 24),

              const Text(
                'Countdown',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Countdown(),
              const SizedBox(height: 24),

              const Text(
                'Buggy Counter — Fixed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const BuggyCounter(),
            ],
          ),
        ),
      ),
    );
  }
}

// StatelessWidget: displays fixed student information.
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
            Text(studentName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            const Text('Roll Number: $rollNumber'),
            const Text('BS Computer Science'),
          ],
        ),
      ),
    );
  }
}

// StatelessWidget: displays the goal progress supplied by its parent.
class GoalBanner extends StatelessWidget {
  final int count;
  final int goal;

  const GoalBanner({super.key, required this.count, required this.goal});

  @override
  Widget build(BuildContext context) {
    final int percentage = count * 100 ~/ goal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Progress: $percentage%'),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: (count / goal).clamp(0.0, 1.0)),
      ],
    );
  }
}

// StatefulWidget: stores and updates the study count when buttons are tapped.
class Tally extends StatefulWidget {
  const Tally({super.key});

  @override
  State<Tally> createState() => _TallyState();
}

class _TallyState extends State<Tally> {
  int _count = startCount;

  void _increase() {
    setState(() {
      _count = (_count + stepSize).clamp(0, maxCount);
    });
  }

  void _decrease() {
    setState(() {
      _count = (_count - stepSize).clamp(0, maxCount);
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
            Text(
              'Study count: $_count / $maxCount',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            GoalBanner(count: _count, goal: maxCount),
            const SizedBox(height: 12),
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
                TextButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// StatefulWidget: updates the countdown every second and counts builds.
class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late int _left;
  Timer? _timer;
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
    _timer?.cancel();
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

// StatefulWidget: demonstrates that changing state must call setState.
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
