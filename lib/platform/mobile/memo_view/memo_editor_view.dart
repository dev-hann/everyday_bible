import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/widgets/memo_editor_controller.dart';
import 'package:flutter/material.dart';

class MemoEditorView extends StatefulWidget {
  MemoEditorView({
    super.key,
    required Memo memo,
  }) : controller = MemoEditorController(memo: memo);
  final MemoEditorController controller;

  static Route route(Memo memo) {
    return MaterialPageRoute(
      builder: (_) {
        return MemoEditorView(memo: memo);
      },
    );
  }

  @override
  State<MemoEditorView> createState() => _MemoEditorViewState();
}

class _MemoEditorViewState extends State<MemoEditorView> {
  AppBar appBar() {
    return AppBar(
      title: const Text("Memo Edit View"),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              widget.controller.memo,
            );
          },
          icon: const Icon(Icons.save),
        ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: TextField(
        controller: widget.controller,
        expands: true,
        maxLines: null,
        minLines: null,
      ),
    );
  }
}
