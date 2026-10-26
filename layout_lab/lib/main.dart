import 'dart:async';

import 'package:flutter/material.dart';

// Do not change the seeded settings.
const String studentName = 'Rafia Naeem';
const String rollNumber = '04072313032';

const int seed = 32;
const int startSec = 20;
const int tick = 3;
const int ticks = 6;
const int stopAt = 38;

const List<String> courses = [
  'Computer Networks',
  'Database Systems',
  'Operating Systems',
  'Software Engineering',
  'Artificial Intelligence',
];

const List<String> names = ['Ali', 'Sara', 'Omar', 'Hina', 'Zain'];

const String course = 'Operating Systems';

const String tileA = 'Omar';
const String tileB = 'Zain';
const String tileC = 'Ali';

const int tapsToMake = 2;

const String mainName = 'end';
const String crossName = 'start';

const double fixedW = 90;
const int flexA = 1;
const int flexB = 1;

const double boxMargin = 10;
const double boxPad = 12;
const double boxRadius = 8;
const double boxBorder = 1;
const String hue = 'teal';

const double dotTop = 16;
const double dotRight = 12;
const double dotBottom = 8;
const double dotLeft = 16;

final List<String> lifecycleLog = [];

void main() {
  runApp(const LabApp());
}

class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team Board - $course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsCard(),
            const SizedBox(height: 12),
            const Welcome(),
            const SizedBox(height: 12),
            const Clock(),
            const SizedBox(height: 12),
            const SwapBoard(),
            const SizedBox(height: 12),
            const InfoPanel(),
            const SizedBox(height: 12),
            const SummaryRow(),
          ],
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('settings'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'YOUR SETTINGS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Name: $studentName'),
            Text('Roll number: $rollNumber'),
            Text('Seed: $seed'),
            Text('Course: $course'),
            Text('Start: $startSec'),
            Text('Tick: $tick'),
            Text('Ticks: $ticks'),
            Text('Stop at: $stopAt'),
            Text('Tiles: $tileA, $tileB, $tileC'),
            Text('Taps to make: $tapsToMake'),
            Text('Main alignment: $mainName'),
            Text('Cross alignment: $crossName'),
          ],
        ),
      ),
    );
  }
}

class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  late Timer _timer;
  int _seconds = startSec;
  int _builds = 0;

  @override
  void initState() {
    super.initState();

    lifecycleLog.add('initState');

    // The timer belongs in initState, not build, so it is not
    // restarted every time Flutter rebuilds this widget.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _seconds += tick;

        if (_seconds >= stopAt) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    lifecycleLog.add('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _builds++;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Session: $_seconds s', key: const Key('clock')),
        Text('Builds: $_builds', key: const Key('builds')),
        Probe(seconds: _seconds),
      ],
    );
  }
}

class Probe extends StatelessWidget {
  final int seconds;

  const Probe({super.key, required this.seconds});

  @override
  Widget build(BuildContext context) {
    final bool above =
        context.findAncestorWidgetOfExactType<Scaffold>() != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Seen at: $seconds s', key: const Key('probe-seen')),
        Text(
          'Widget #${identityHashCode(this)}',
          key: const Key('probe-widget'),
        ),
        Text(
          'Element #${identityHashCode(context)}',
          key: const Key('probe-element'),
        ),
        Text(
          'Context belongs to: ${context.widget.runtimeType}',
          key: const Key('probe-context'),
        ),
        Text('Scaffold above me: $above', key: const Key('probe-above')),
      ],
    );
  }
}

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome, $studentName', key: const Key('welcome')),
    );
  }
}

class Tile extends StatefulWidget {
  final String label;

  const Tile(this.label, {super.key});

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  int taps = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          taps++;
        });
      },
      child: Text('${widget.label}: $taps'),
    );
  }
}

class SwapBoard extends StatefulWidget {
  const SwapBoard({super.key});

  @override
  State<SwapBoard> createState() => _SwapBoardState();
}

class _SwapBoardState extends State<SwapBoard> {
  var tiles = [
    Tile(tileA, key: ValueKey(tileA)),
    Tile(tileB, key: ValueKey(tileB)),
    Tile(tileC, key: ValueKey(tileC)),
  ];

  void swap() {
    setState(() {
      tiles = tiles.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Think: Widget describes the UI, Element connects it to the
    // tree, and State stores changing data. ValueKeys help Flutter
    // match each tile with its existing Element and State after reordering.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: tiles),
        const SizedBox(height: 12),
        ElevatedButton(
          key: const Key('swap'),
          onPressed: swap,
          child: const Text('Swap'),
        ),
      ],
    );
  }
}

class InfoPanel extends StatelessWidget {
  const InfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Think: Row arranges children horizontally, while Column
    // arranges children vertically.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          key: const Key('info-row'),
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Start: $startSec s', key: const Key('row-a')),
            const SizedBox(width: 12),
            Text('Tick: $tick s', key: const Key('row-b')),
            const SizedBox(width: 12),
            Text('Stop: $stopAt s', key: const Key('row-c')),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          key: const Key('info-col'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $studentName', key: const Key('col-a')),
            Text('Roll no: $rollNumber', key: const Key('col-b')),
            Text('Course: $course', key: const Key('col-c')),
          ],
        ),
      ],
    );
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Name: $studentName', key: const Key('sum-a')),
        Text('Roll: $rollNumber', key: const Key('sum-b')),
        Text('Course: $course', key: const Key('sum-c')),
      ],
    );
  }
}
