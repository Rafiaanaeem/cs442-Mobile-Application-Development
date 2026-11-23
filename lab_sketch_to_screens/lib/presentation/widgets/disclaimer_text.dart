import 'package:material_ui/material_ui.dart';

import '../../data/sample_data.dart';

/// The health disclaimer required by the course brief.
/// Shown on Welcome, Account access and Settings.
class DisclaimerText extends StatelessWidget {
  const DisclaimerText({super.key, this.textAlign});

  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) => Text(
    disclaimer,
    textAlign: textAlign,
    style: Theme.of(context).textTheme.bodySmall,
  );
}
