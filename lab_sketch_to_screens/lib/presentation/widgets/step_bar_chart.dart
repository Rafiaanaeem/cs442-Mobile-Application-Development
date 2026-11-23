import 'package:material_ui/material_ui.dart';

import '../../app/format.dart';

/// One bar: its label under the axis (may be empty) and the steps.
/// Null steps means the day was not tracked, so no bar is drawn.
typedef StepBar = ({String label, String tooltip, int? steps});

/// A simple bar chart built from plain widgets, so no chart package and no
/// pixel sizes are needed. The dashed goal line is drawn as a thin line.
/// fl_chart replaces it once real step data arrives.
class StepBarChart extends StatelessWidget {
  const StepBarChart({super.key, required this.bars, required this.goal});

  final List<StepBar> bars;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.labelSmall;

    var highest = goal;
    for (final b in bars) {
      if ((b.steps ?? 0) > highest) highest = b.steps!;
    }
    final top = highest * 1.15;
    final gap = bars.length > 7 ? 1.0 : 8.0;

    // Alignment runs from -1 (left/top) to 1 (right/bottom).
    double xOf(int i) => -1 + 2 * (i + 0.5) / bars.length;

    // Twice as wide as tall on a phone; capped on a wide browser window.
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 280),
      child: AspectRatio(
        aspectRatio: 2,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final b in bars)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: gap),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: b.steps == null
                                  ? null
                                  : FractionallySizedBox(
                                      heightFactor: b.steps! / top,
                                      widthFactor: 1,
                                      child: Tooltip(
                                        message: b.tooltip,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: b.steps! >= goal
                                                ? scheme.primary
                                                : scheme.secondary.withValues(
                                                    alpha: 0.55,
                                                  ),
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(3),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // The goal line.
                  Align(
                    alignment: Alignment(0, 1 - 2 * goal / top),
                    child: Container(height: 1, color: scheme.outline),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: scheme.outlineVariant),
            const SizedBox(height: 4),
            Stack(
              children: [
                // Keeps the row one line tall even if every label is empty.
                Text(' ', style: labelStyle),
                for (var i = 0; i < bars.length; i++)
                  if (bars[i].label.isNotEmpty)
                    Align(
                      alignment: Alignment(xOf(i), 0),
                      child: Text(bars[i].label, style: labelStyle),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Bars for the current Monday-to-Sunday week. Days after today are empty.
List<StepBar> weekBars(int? Function(int daysAgo) stepsOn) {
  final daysIntoWeek = today().weekday - 1;
  return [
    for (var i = 0; i < 7; i++)
      (
        label: weekdayLetters[i],
        tooltip: i <= daysIntoWeek
            ? '${dayLabel(daysIntoWeek - i)}: '
                  '${_stepsText(stepsOn(daysIntoWeek - i))}'
            : '',
        steps: i <= daysIntoWeek ? stepsOn(daysIntoWeek - i) : null,
      ),
  ];
}

/// Bars for the current calendar month, labelled every five days.
List<StepBar> monthBars(int? Function(int daysAgo) stepsOn) {
  final t = today();
  final daysInMonth = DateTime(t.year, t.month + 1, 0).day;
  return [
    for (var day = 1; day <= daysInMonth; day++)
      (
        label: day == 1 || day % 5 == 0 ? '$day' : '',
        tooltip: day <= t.day
            ? '${dayLabel(t.day - day)}: ${_stepsText(stepsOn(t.day - day))}'
            : '',
        steps: day <= t.day ? stepsOn(t.day - day) : null,
      ),
  ];
}

String _stepsText(int? steps) =>
    steps == null ? 'not tracked' : '${formatCount(steps)} steps';
