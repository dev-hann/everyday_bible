import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/widgets/memo_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

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
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction(
            icon: const Icon(FLucideIcons.arrowLeft),
            onPress: () => Navigator.pop(context),
          ),
        ],
        suffixes: [
          FHeaderAction(
            icon: const Icon(FLucideIcons.save),
            onPress: () {
              Navigator.pop(
                context,
                widget.controller.memo,
              );
            },
          ),
        ],
        title: const Text('Memo Edit View'),
      ),
      child: FTextField.multiline(
        control: FTextFieldControl.managed(controller: widget.controller),
        expands: true,
        minLines: null,
      ),
    );
  }
}
