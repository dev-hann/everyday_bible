import 'package:everydaybible/model/memo/memo.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Text editing controller that mirrors edits into a [Memo] and renders
/// its first line as a large title.
class MemoEditorController extends TextEditingController {
  /// Creates a controller editing [memo]'s raw text.
  MemoEditorController({
    required this.memo,
  }) : super(text: memo.rawText);

  /// Memo kept in sync with the edited text.
  Memo memo;

  @override
  set value(TextEditingValue newValue) {
    memo = memo.copyWith(
      rawText: newValue.text,
    );
    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    final titleStyle = FTheme.of(
      context,
    ).typography.display.sm.copyWith(fontWeight: FontWeight.w600);
    return TextSpan(
      children: [
        TextSpan(
          text: '${memo.title}\n',
          style: titleStyle,
        ),
        TextSpan(text: memo.content),
      ],
    );
  }
}
