import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/widgets/memo_editor_controller.dart';
import 'package:fluent_ui/fluent_ui.dart';

class MemoEditView extends StatefulWidget {
  MemoEditView({
    super.key,
    required int windowID,
    required Map<String, dynamic> memoData,
  })  : memoController = MemoEditorController(memo: Memo.fromMap(memoData)),
        windowController = WindowController.fromWindowId(windowID);

  final MemoEditorController memoController;
  final WindowController windowController;
  static void show(Memo memo) async {
    final window = await DesktopMultiWindow.createWindow(
      jsonEncode(memo.toMap()),
    );
    window
      ..setFrame(const Offset(0, 0) & const Size(400, 600))
      ..setTitle(memo.title)
      ..show();
  }

  @override
  State<MemoEditView> createState() => _MemoEditViewState();
}

class _MemoEditViewState extends State<MemoEditView> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            child: TextBox(
              controller: widget.memoController,
              // focusNode: state.focusNode,
              expands: true,
              maxLines: null,
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.transparent,
              //   ),
              // ),
              highlightColor: Colors.transparent,
              onChanged: (_) async {
                final memo = widget.memoController.memo;
                await DesktopMultiWindow.invokeMethod(
                  0,
                  "onUpdated",
                  jsonEncode(memo.toMap()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
