import 'package:material_ui/material_ui.dart';

/// Shared widget: a coloured box with an icon, used instead of image files.
/// The wger exercise photos replace it in the REST lab.
class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    super.key,
    this.icon = Icons.image_outlined,
    this.label,
    this.aspectRatio = 16 / 9,
  });

  final IconData icon;
  final String? label;

  /// Width divided by height. Null fills the space it is given (grid tiles).
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final box = DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      // FittedBox shrinks the icon when the box is small, for example while
      // the Hero animation is flying, so nothing overflows.
      child: Center(
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 64, color: scheme.onPrimaryContainer),
                if (label != null)
                  Text(
                    label!,
                    style: TextStyle(color: scheme.onPrimaryContainer),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    return aspectRatio == null
        ? box
        : AspectRatio(aspectRatio: aspectRatio!, child: box);
  }
}
