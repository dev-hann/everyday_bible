import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/platform/desktop/memo_view/bloc/memo_bloc.dart';
import 'package:everydaybible/widgets/memo_editor_controller.dart';
import 'package:everydaybible/widgets/memo_list_tile/desktop_memo_list_tile.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemoView extends StatefulWidget {
  const MemoView({super.key});

  @override
  State<MemoView> createState() => _MemoViewState();
}

class _MemoViewState extends State<MemoView> {
  MemoBloc get bloc => BlocProvider.of(context);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text("Memo"),
        commandBar: IconButton(
          icon: const Icon(FluentIcons.add_notes),
          onPressed: () {
            bloc.add(MemoEventUpdatedMemo(Memo()));
          },
        ),
      ),
      content: Row(
        children: [
          Expanded(
            flex: 3,
            child: BlocBuilder<MemoBloc, MemoState>(
              buildWhen: (previous, current) {
                return previous.memoList != current.memoList ||
                    previous.selectedMemo != current.selectedMemo;
              },
              builder: (context, state) {
                final list = state.memoList;
                final selectedMemo = state.selectedMemo;
                return ListView(
                  children: list.map((memo) {
                    return DesktopMemoListTile(
                      isSelected: selectedMemo?.index == memo.index,
                      memo: memo,
                      onTap: () {
                        bloc.add(
                          MemoEventSelectedMemo(memo),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const Divider(direction: Axis.vertical),
          Expanded(
            flex: 7,
            child: BlocBuilder<MemoBloc, MemoState>(
              buildWhen: (previous, current) {
                return previous.selectedMemo?.index !=
                    current.selectedMemo?.index;
              },
              builder: (context, state) {
                final selectedMemo = state.selectedMemo;
                if (selectedMemo == null) {
                  return IconButton(
                    onPressed: () {
                      bloc.add(
                        MemoEventSelectedMemo(Memo()),
                      );
                    },
                    icon: const Center(
                      child: Icon(FluentIcons.add),
                    ),
                  );
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final controller = MemoEditorController(
                      memo: selectedMemo,
                    );
                    return SizedBox(
                      height: constraints.maxHeight,
                      child: TextBox(
                        controller: controller,
                        focusNode: state.focusNode,
                        expands: true,
                        maxLines: null,
                        onChanged: (_) {
                          bloc.add(
                            MemoEventUpdatedMemo(controller.memo),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
