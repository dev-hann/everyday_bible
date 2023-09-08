import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/platform/desktop/memo_edit_view/memo_edit_view.dart';
import 'package:everydaybible/platform/desktop/memo_view/bloc/memo_bloc.dart';
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
            final memo = Memo();
            bloc.add(MemoEventUpdatedMemo(memo));
            MemoEditView.show(memo);
          },
        ),
      ),
      content: BlocBuilder<MemoBloc, MemoState>(
        buildWhen: (previous, current) {
          return previous.memoList != current.memoList ||
              previous.selectedMemo != current.selectedMemo;
        },
        builder: (context, state) {
          final list = state.memoList;
          final selectedMemo = state.selectedMemo;

          if (list.isEmpty) {
            return IconButton(
              onPressed: () {
                final memo = Memo();
                bloc.add(MemoEventUpdatedMemo(memo));
                MemoEditView.show(memo);
              },
              icon: const Center(
                child: Icon(FluentIcons.add),
              ),
            );
          }
          return ListView(
            children: list.map((memo) {
              return DesktopMemoListTile(
                isSelected: selectedMemo == memo,
                memo: memo,
                onTapDelete: () {
                  bloc.add(
                    MemoEventRemoveddMemo(memo),
                  );
                },
                onTap: () async {
                  bloc.add(
                    MemoEventUpdatedMemo(memo),
                  );
                  MemoEditView.show(memo);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
