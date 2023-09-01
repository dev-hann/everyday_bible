import 'package:flutter/cupertino.dart';

class BibleLogo extends StatelessWidget {
  const BibleLogo({
    super.key,
    this.size = 24.0,
  });
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Image.asset(
        "assets/logo.png",
      ),
    );
  }
}
