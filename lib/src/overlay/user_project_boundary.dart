import 'package:flutter/widgets.dart';

/// A marker widget that indicates the start of the user's project widget tree.
/// WidgetPicker will only select widgets that are descendants of this widget.
class UserProjectBoundary extends StatelessWidget {
  final Widget child;

  const UserProjectBoundary({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
