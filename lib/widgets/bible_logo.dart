import 'package:flutter/cupertino.dart';

/// App logo image, drawn as a square of [size].
class BibleLogo extends StatelessWidget {
  /// Creates the logo widget.
  const BibleLogo({
    super.key,
    this.size = 24.0,
  });

  /// Width and height of the logo square.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Image.asset(
        'assets/logo.png',
      ),
    );
  }
}
