import 'package:everydaybible/models/bible/bible_chapter.dart';
import 'package:everydaybible/models/bible/bible_data.dart';
import 'package:everydaybible/models/bible/bible_verse.dart';
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

class _BibleViewState extends State<BibleView> {
  BibleBloc get bloc => BlocProvider.of(context);

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
          Text(data.title),
          for (final item in data.chatperList)
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
        final currentChapter = state.currentChapter;
        final verseList = state.verseList;
        final currentData = dataList.where(
            (element) => currentChapter?.usfm.contains(element.usfm) ?? false);

        return Scaffold(
          key: state.drawerKey,
          appBar: appBar(
            title: currentData.first.title,
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
            children: verseList.map((e) {
              return VerseText(index: e.index, text: e.text);
            }).toList(),
          ),
        );
      },
    );
  }
}
