import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/platform/mobile/memo_view/bloc/memo_bloc.dart';
import 'package:everydaybible/platform/mobile/memo_view/memo_editor_view.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:everydaybible/widgets/memo_list_tile/mobile_memo_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemoView extends StatefulWidget {
  const MemoView({super.key});

  @override
  State<MemoView> createState() => _MemoViewState();
}

class _MemoViewState extends State<MemoView> {
  MemoBloc get bloc => BlocProvider.of(context);

  AppBar appBar() {
    return AppBar(
      title: const Text("Memo"),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MemoEditorView.route(Memo()),
            ).then((edited) {
              if (edited != null) {
                bloc.add(MemoEventUpdatedMemo(edited));
              }
            });
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: BlocBuilder<MemoBloc, MemoState>(
        builder: (context, state) {
          final status = state.status;
          switch (status) {
            case MemoViewStatus.init:
              return const BibleLoading();
            case MemoViewStatus.loading:
            case MemoViewStatus.failure:
            case MemoViewStatus.success:
          }
          final list = state.memoList;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: list.map((memo) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  child: MobileMemoListTile(
                    memo: memo,
                    onTap: () {
                      Navigator.push(
                        context,
                        MemoEditorView.route(memo),
                      ).then((edited) {
                        if (edited != null) {
                          bloc.add(
                            MemoEventUpdatedMemo(edited),
                          );
                        }
                      });
                    },
                    onTapDelete: () {
                      bloc.add(
                        MemoEventRemovedMemo(memo),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
