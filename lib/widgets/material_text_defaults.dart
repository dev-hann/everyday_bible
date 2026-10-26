import 'package:flutter/material.dart';

/// Wraps [child] in a transparent [Material] so bare [Text] widgets inherit
/// a themed [DefaultTextStyle].
///
/// forui screens (`FScaffold`) do not provide a [Material] ancestor, so text
/// rendered outside Material widgets falls back to the debug-style
/// yellow-underlined text. Wrapping the app's navigator with this widget
/// restores Material text defaults for every route.
class MaterialTextDefaults extends StatelessWidget {
  /// Creates the wrapper.
  const MaterialTextDefaults({
    required this.child,
    super.key,
  });

  /// The subtree that gains Material text defaults.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: child,
    );
  }
}
