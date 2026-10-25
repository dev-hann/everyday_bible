import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/widgets/memo_editor_controller.dart';
import 'package:flutter/material.dart';

/// Full-screen editor for a single memo; pops with the edited memo when the
/// save button is pressed.
class MemoEditorView extends StatefulWidget {
  /// Creates an editor pre-filled with [memo].
  MemoEditorView({
    required Memo memo,
    super.key,
  }) : controller = MemoEditorController(memo: memo);

  /// Editing controller that owns the memo being edited.
  final MemoEditorController controller;

  /// Returns the route that opens the editor for [memo]; the route pops
  /// with the edited memo, or `null` when dismissed.
  static Route<Memo?> route(Memo memo) {
    return MaterialPageRoute<Memo?>(
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
      title: const Text('Memo Edit View'),
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
      ),
    );
  }
}
