import 'package:collection/collection.dart';
import 'package:everydaybible/model/bible/bible_chapter.dart';
import 'package:everydaybible/model/bible/bible_data.dart';
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
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.name),
          for (final item in data.chapterList)
            GestureDetector(
              onTap: () {
                onTapChapter(item);
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  backgroundColor: isSelected(item) ? Colors.orange : null,
                  child: Center(
                    child: Text(
                      "${item.number}장",
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget verseListView({
    required List<String> verseList,
    required ScrollController scrollController,
  }) {
    if (verseList.isEmpty) {
      return const BibleLoading();
    }
    return ListView(
      controller: scrollController,
      children: [
        for (int index = 0; index < verseList.length; index++)
          VerseText(
            index: index + 1,
            text: verseList[index],
          )
      ],
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
        final currentChapter = state.selectedChapter!;
        final verseList = currentChapter.verseList;

        final currentData = dataList.firstWhereOrNull(
            (element) => element.chapterList.contains(currentChapter))!;
        return ScaffoldPage.withPadding(
          header: PageHeader(
            title: Text(
              "${currentData.name} ${currentChapter.number}장",
            ),
          ),
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
              const SizedBox(width: 8.0),
              Expanded(
                flex: 9,
                child: verseListView(
                  verseList: verseList,
                  scrollController: state.scrollController,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
