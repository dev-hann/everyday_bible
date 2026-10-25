import 'dart:async';

import 'package:everydaybible/model/bible/bible_chapter.dart';
import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:everydaybible/platform/mobile/bible_drawer_view/bible_drawer_view.dart';
import 'package:everydaybible/platform/mobile/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

/// Bible reader screen: shows the verses of the selected book and chapter
/// and opens a side sheet for navigating between them.
class BibleView extends StatefulWidget {
  /// Creates the Bible reader screen.
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

  void showChapterSheet({
    required List<BibleData> dataList,
    required BibleData currentData,
    required BibleChapter currentChapter,
  }) {
    unawaited(
      showFSheet<void>(
        context: context,
        side: FLayout.ltr,
        mainAxisMaxRatio: 0.85,
        builder: (context) => BlocProvider<BibleBloc>.value(
          value: bloc,
          child: BibleDrawerView(
            dataList: dataList,
            currentData: currentData,
            currentChapter: currentChapter,
            onTapChapter: (data, chapter) {
              bloc.add(
                BibleEventUpdatedChapter(data, chapter),
              );
            },
          ),
        ),
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
        final currentData = state.selectedData!;
        final currentChapter = state.selectedChapter!;
        final verseList = currentChapter.verseList;

        return FScaffold(
          header: FHeader.nested(
            prefixes: [
              FHeaderAction(
                icon: const Icon(FLucideIcons.list),
                onPress: () => showChapterSheet(
                  dataList: dataList,
                  currentData: currentData,
                  currentChapter: currentChapter,
                ),
              ),
            ],
            title: Text('${currentData.name} ${currentChapter.number}장'),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
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
