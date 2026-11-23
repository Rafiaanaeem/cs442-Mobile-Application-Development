import 'package:material_ui/material_ui.dart';

/// Shared widget 1: a tappable card with an icon, a title and one line of
/// detail. Used for every list on every screen.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.circle,
    this.onTap,
    this.trailing,
    this.footer,
    this.heroTag,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  /// Replaces the chevron, for example with a button.
  final Widget? trailing;

  /// Shown under the subtitle, for example a progress bar.
  final Widget? footer;

  /// When set, the icon flies to the detail screen (Hero animation).
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final leading = Icon(icon);
    return Card(
      child: ListTile(
        leading: heroTag == null
            ? leading
            : Hero(tag: heroTag!, child: leading),
        title: Text(title),
        subtitle: footer == null
            ? (subtitle == null ? null : Text(subtitle!))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (subtitle != null) Text(subtitle!),
                  const SizedBox(height: 8),
                  footer!,
                ],
              ),
        trailing:
            trailing ??
            (onTap == null ? null : const Icon(Icons.chevron_right)),
        onTap: onTap,
      ),
    );
  }
}
