import 'package:everydaybible/model/memo/memo.dart';
import 'package:flutter/material.dart';

class MemoEditorController extends TextEditingController {
  MemoEditorController({
    required this.memo,
  }) : super(text: memo.rawText);
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
    TextStyle? style,
    required bool withComposing,
  }) {
    return TextSpan(
      children: [
        TextSpan(
          text: "${memo.title}\n",
          style: const TextStyle(fontSize: 30),
        ),
        TextSpan(text: memo.content),
      ],
    );
  }
}
