import 'package:material_ui/material_ui.dart';

/// Shared widget 3: a bold heading above a group of items.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});

  final String text;

  /// Optional small widget on the right, such as an icon button.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ?trailing, // added only when not null
      ],
    ),
  );
}
