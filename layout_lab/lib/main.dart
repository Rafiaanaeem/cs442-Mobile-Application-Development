
import 'dart:async';

import 'package:flutter/material.dart';

const String studentName = 'Rafia Naeem';
const String rollNo = '04072313032';

// ===== Seeded settings (generated from YOUR roll number). Do not edit. =====
final int seed = int.parse(rollNo.substring(rollNo.length - 2));
final int t = seed ~/ 10;
final int u = seed % 10;

const List<String> courses = [
  'Mobile Dev',
  'Data Structures',
  'Operating Systems',
  'Databases',
  'Networks',
  'Software Eng',
  'AI',
  'Web Engineering',
  'Graphics',
  'Security',
];

const List<String> names = ['Ali', 'Sara', 'Omar', 'Hina', 'Zain', 'Maya'];

const List<String> mains = [
  'start',
  'center',
  'end',
  'spaceBetween',
  'spaceAround',
  'spaceEvenly',
];

const List<String> crosses = ['start', 'center', 'end'];

const List<String> hues = ['teal', 'indigo', 'orange', 'pink', 'green'];

const Map<String, MaterialColor> swatches = {
  'teal': Colors.teal,
  'indigo': Colors.indigo,
  'orange': Colors.orange,
  'pink': Colors.pink,
  'green': Colors.green,
};

final String course = courses[u];

// Steps 1–2: Clock settings
final int startSec = 5 * (1 + t % 5);
final int tick = 1 + u % 3;
final int ticks = 4 + u % 4;
final int stopAt = startSec + ticks * tick;

// Steps 4–5: Tile settings
final String tileA = names[u % 6];
final String tileB = names[(u + 2) % 6];
final String tileC = names[(u + 4) % 6];
final int tapsToMake = 2 + t % 3;

// Step 6: Alignment settings
final String mainName = mains[u % 6];
final String crossName = crosses[t % 3];

// Step 8: Expanded and Flexible settings
final double fixedW = 70.0 + 10 * u;
final int flexA = 1 + t % 3;
final int flexB = 1 + u % 2;

// Step 9: Container settings
final double boxMargin = 4.0 + 2 * (t % 5);
final double boxPad = 8.0 + 2 * (u % 5);
final double boxRadius = 4.0 * (1 + (t + u) % 4);
final double boxBorder = 1.0 + t % 3;
final String hue = hues[(t + u) % 5];

// Step 10: Stack settings (preserved for Step 10)
final double dotTop = 4.0 + 4 * (t % 4);
final double dotRight = 4.0 + 4 * (u % 4);
final double dotBottom = 4.0 + 4 * ((t + u) % 4);
final double dotLeft = 4.0 + 4 * ((t + 2 * u) % 4);
// ==========================================================================

final List<String> lifecycleLog = <String>[];

void main() => runApp(const LabApp());

class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Team Board',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team Board: $course')),
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
            const SizedBox(height: 12),
            const ShareRow(),
            const SizedBox(height: 12),
            const InfoBox(),
          ],
        ),
      ),
    );
  }
}

// Provided widget: shows your personalized settings.
class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'YOUR SETTINGS (seed $seed)\n'
      'clock: start $startSec, tick $tick, stop at $stopAt\n'
      'tiles: $tileA, $tileB, $tileC (taps for the Step 5 experiment: '
      '$tapsToMake)\n'
      'row main axis: $mainName | column cross axis: $crossName\n'
      'flex: $flexA and $flexB | fixed width: ${fixedW.toStringAsFixed(0)}\n'
      'box: margin $boxMargin, padding $boxPad, radius $boxRadius, '
      'border $boxBorder, colour $hue\n'
      'stamp: top $dotTop, right $dotRight, bottom $dotBottom, left $dotLeft',
      key: const Key('settings'),
      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
    );
  }
}

// Step 1 and Step 2: Clock, timer, lifecycle and build count.
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

    // Think: initState runs once. Starting a timer in build would create
    // additional timers on every rebuild and make the clock run too fast.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _seconds += tick);

      if (_seconds >= stopAt) {
        timer.cancel();
      }
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

    // Think: setState triggers one rebuild for each timer tick. Without
    // cancelling the timer in dispose, it could call setState after disposal.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session: $_seconds s',
          key: const Key('clock'),
        ),
        Text(
          'Builds: $_builds',
          key: const Key('builds'),
        ),
        // Do not make Probe const: it must be recreated to show the new Widget ID.
        Probe(seconds: _seconds),
      ],
    );
  }
}

// Step 3: BuildContext, Widget and Element.
class Probe extends StatelessWidget {
  final int seconds;

  const Probe({super.key, required this.seconds});

  @override
  Widget build(BuildContext context) {
    final bool above =
        context.findAncestorWidgetOfExactType<Scaffold>() != null;

    // Think: Widget configurations are recreated; the Element maintains
    // the widget's place in the tree. A RenderObject handles layout and painting.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seen at: $seconds s',
          key: const Key('probe-seen'),
        ),
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
        Text(
          'Scaffold above me: $above',
          key: const Key('probe-above'),
        ),
      ],
    );
  }
}

// Step 4: Welcome widget built through composition.
class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    // Think: Composition combines existing widgets instead of subclassing
    // a built-in widget such as Text or ElevatedButton.
    return Center(
      child: Text(
        'Welcome, $studentName',
        key: const Key('welcome'),
      ),
    );
  }
}

// Step 4: A stateful tile.
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
      onPressed: () => setState(() => taps++),
      child: Text('${widget.label}: $taps'),
    );
  }
}

// Step 5: Tiles with ValueKeys so State follows each label when reordered.
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

  void swap() => setState(() => tiles = tiles.reversed.toList());

  @override
  Widget build(BuildContext context) {
    // Think: Without keys, Flutter can reuse an Element by widget type and
    // position, leaving its State at that position as labels move. ValueKeys
    // identify the widgets so their Elements and State follow their labels.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: tiles),
        ElevatedButton(
          key: const Key('swap'),
          onPressed: swap,
          child: const Text('Swap'),
        ),
      ],
    );
  }
}

// Step 6: Row and Column alignment.
class InfoPanel extends StatelessWidget {
  const InfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Think: A Column's main axis is vertical. Its cross axis is horizontal,
    // so CrossAxisAlignment.center moves children left or right.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          key: const Key('info-row'),
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Start: $startSec s',
              key: const Key('row-a'),
            ),
            Text(
              'Tick: $tick s',
              key: const Key('row-b'),
            ),
            Text(
              'Stop: $stopAt s',
              key: const Key('row-c'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          key: const Key('info-col'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $studentName',
              key: const Key('col-a'),
            ),
            Text(
              'Roll no: $rollNo',
              key: const Key('col-b'),
            ),
            Text(
              'Course: $course',
              key: const Key('col-c'),
            ),
          ],
        ),
      ],
    );
  }
}

// Step 7: Expanded fixes the intentional Row overflow.
class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key});

  @override
  Widget build(BuildContext context) {
    // Think: Constraints go down from Row to Expanded's child. Expanded gives
    // each Text a limited width; sizes go up, and the Text wraps within it.
    return Row(
      children: [
        Expanded(
          child: Text(
            'Part A: read the widget tree of the $course board from top to bottom.',
            key: const Key('sum-a'),
          ),
        ),
        Expanded(
          child: Text(
            'Part B: build each box from small widgets and never extend a built-in class.',
            key: const Key('sum-b'),
          ),
        ),
        Expanded(
          child: Text(
            'Part C: break the layout on purpose, then fix it with Expanded or Wrap.',
            key: const Key('sum-c'),
          ),
        ),
      ],
    );
  }
}

// Step 8: Fixed width, Expanded and Flexible.
class ShareRow extends StatelessWidget {
  const ShareRow({super.key});

  @override
  Widget build(BuildContext context) {
    // Think: Expanded is Flexible with FlexFit.tight. It must fill its share.
    // Flexible can use less than its allocated share. Swapping them changes
    // which button is forced to fill the available space.
    return Row(
      key: const Key('share-row'),
      children: [
        SizedBox(
          key: const Key('fixed'),
          width: fixedW,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('F'),
          ),
        ),
        Expanded(
          flex: flexA,
          child: ElevatedButton(
            key: const Key('exp'),
            onPressed: () {},
            child: const Text('Exp'),
          ),
        ),
        Flexible(
          flex: flexB,
          child: ElevatedButton(
            key: const Key('flex'),
            onPressed: () {},
            child: const Text('Flex'),
          ),
        ),
      ],
    );
  }
}

// Step 9: Container with margin, padding and decoration.
class InfoBox extends StatelessWidget {
  const InfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    // Think: Margin is outside the border; padding is inside the border,
    // between the border and child. Padding is enough for internal spacing;
    // SizedBox is useful for a fixed gap or size. Container adds decoration
    // and other features when they are needed.
    return Container(
      key: const Key('info-box'),
      margin: EdgeInsets.all(boxMargin),
      padding: EdgeInsets.all(boxPad),
      decoration: BoxDecoration(
        color: swatches[hue]!.shade100,
        borderRadius: BorderRadius.circular(boxRadius),
        border: Border.all(width: boxBorder),
      ),
      child: Text(
        'Course: $course',
        key: const Key('box-text'),
      ),
    );
  }
}
