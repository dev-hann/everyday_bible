import 'package:flutter/material.dart';

/// Renders a single Bible verse: a numbered heading row plus its text.
class VerseText extends StatelessWidget {
  /// Creates a verse text widget.
  const VerseText({
    required this.index,
    required this.text,
    super.key,
  });

  /// Verse number shown in the heading row.
  final int index;

  /// Body text of the verse.
  final String text;

  /// Builds the heading row showing the verse number and a divider.
  Widget indexView() {
    return Row(
      children: [
        Text('$index'),
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
          padding: const EdgeInsets.all(8),
          child: SelectableText(text),
        ),
      ],
    );
  }
}
