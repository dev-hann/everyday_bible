import 'package:everydaybible/platform/mobile/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/widgets/bible_drawer.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BibleView extends StatefulWidget {
  const BibleView({super.key});

  @override
  State<BibleView> createState() => _BibleViewState();
}

class _BibleViewState extends State<BibleView>
    with AutomaticKeepAliveClientMixin {
  BibleBloc get bloc => BlocProvider.of(context);

  @override
  void initState() {
    super.initState();
    bloc.add(const BibleEventInited());
  }

  AppBar appBar({
    required String? title,
  }) {
    return AppBar(
      title: Text(title ?? "Bible"),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<BibleBloc, BibleState>(
      builder: (context, state) {
        final status = state.status;
        switch (status) {
          case BibleViewStatus.init:
            return const BibleLoading();
          case BibleViewStatus.loading:
          case BibleViewStatus.failure:
          case BibleViewStatus.success:
        }
        final dataList = state.bibleDataList;
        final currentData = state.selectedData!;
        final currentChapter = state.selectedChapter!;
        final verseList = currentChapter.verseList;

        return Scaffold(
          key: state.drawerKey,
          appBar: appBar(
            title: "${currentData.name} ${currentChapter.number}장",
          ),
          drawer: BibleDrawer(
            dataList: dataList,
            currentChapter: currentChapter,
            onTapChapter: (data, chapter) {
              bloc.add(
                BibleEventUpdatedChapter(data, chapter),
              );
            },
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              for (int index = 0; index < verseList.length; index++)
                VerseText(
                  index: index + 1,
                  text: verseList[index],
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
