import 'package:collection/collection.dart';
import 'package:everydaybible/model/bible/bible_chapter.dart';
import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:everydaybible/platform/mobile/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/widgets/bible_drawer.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:collection';

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

  Widget capterList({
    required BibleData data,
    required bool Function(BibleChapter chapter) isSelected,
    required Function(BibleChapter chapter) onTapChapter,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.name),
          for (final item in data.chapterList)
            GestureDetector(
              onTap: () {
                onTapChapter(item);
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isSelected(item) ? Colors.orange : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Text("${item.number}장"),
                ),
              ),
            )
        ],
      ),
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
        final currentChapter = state.selectedChapter!;
        final verseList = currentChapter.verseList;
        final currentData = dataList.firstWhereOrNull(
            (element) => element.chapterList.contains(currentChapter));

        return Scaffold(
          key: state.drawerKey,
          appBar: appBar(
            title: currentData?.name,
          ),
          drawer: BibleDrawer(
            dataList: dataList,
            currentChapter: currentChapter,
            onTapChapter: ((chapter) {
              bloc.add(
                BibleEventUpdatedChapter(chapter),
              );
            }),
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
