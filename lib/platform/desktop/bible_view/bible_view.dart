import 'package:everydaybible/model/bible/bible_chapter.dart';
import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:everydaybible/model/bible/bible_verse.dart';
import 'package:everydaybible/platform/desktop/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BibleView extends StatefulWidget {
  const BibleView({super.key});

  @override
  State<BibleView> createState() => _BibleViewState();
}

class _BibleViewState extends State<BibleView> {
  BibleBloc get bloc => BlocProvider.of(context);

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

  Widget verseListView(List<BibleVerse> verseList) {
    if (verseList.isEmpty) {
      return const BibleLoading();
    }
    return ListView(
      children: verseList.map((e) {
        return VerseText(
          index: e.index,
          text: e.text,
        );
      }).toList(),
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
        return ScaffoldPage.withPadding(
          header: const Text("Title"),
          content: Row(
            children: [
              Expanded(
                flex: 1,
                child: ListView(
                  children: dataList.map((e) {
                    return capterList(
                      data: e,
                      isSelected: (chapter) {
                        return currentChapter == chapter;
                      },
                      onTapChapter: (chapter) {
                        bloc.add(
                          BibleEventUpdatedChapter(chapter),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                flex: 9,
                child: verseListView(verseList),
              ),
            ],
          ),
        );
      },
    );
  }
}
