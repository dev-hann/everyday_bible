import 'package:flutter/material.dart';

class GospelText extends StatelessWidget {
  const GospelText({
    super.key,
    required this.index,
    required this.text,
  });
  final String index;
  final String text;
  Widget indexView() {
    return Row(
      children: [
        Text(index),
        const SizedBox(width: 8),
        const Expanded(child: Divider()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        indexView(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text),
        ),
      ],
    );
  }
}
