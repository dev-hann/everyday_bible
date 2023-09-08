import 'package:everydaybible/model/bible/bible_chapter.dart';
import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:everydaybible/platform/desktop/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highlight_text/highlight_text.dart';

class BibleView extends StatefulWidget {
  const BibleView({super.key});

  @override
  State<BibleView> createState() => _BibleViewState();
}

class _BibleViewState extends State<BibleView> {
  BibleBloc get bloc => BlocProvider.of(context);

  Widget chapterListDialog({
    required List<BibleData> dataList,
    required BibleChapter currentChapter,
    required Function(BibleData data, BibleChapter chapter) onTapChapter,
  }) {
    final TextEditingController searchController = TextEditingController();
    return Center(
      child: Card(
        backgroundColor: Colors.black,
        child: Column(
          children: [
            TextBox(
              controller: searchController,
            ),
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: searchController,
                  builder: (context, value, _) {
                    final query = value.text;
                    final list = dataList
                        .where((element) => element.name.contains(query))
                        .toList();
                    if (list.isEmpty) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 16.0,
                      ),
                      child: TreeView(
                        items: list.map((data) {
                          final title = data.name;
                          return TreeViewItem(
                            lazy: true,
                            content: Text(title),

                            /// TODO: [TextHelight] Widget is too slow draw UI..
                            // content: TextHighlight(
                            //   words: {
                            //     query: HighlightedWord(
                            //       textStyle:
                            //           TextStyle(color: Colors.orange.light),
                            //     )
                            //   },
                            //   text: title,
                            // ),
                            onExpandToggle: (item, getsExpanded) async {
                              if (item.children.isNotEmpty) {
                                return;
                              }
                              item.children.addAll(
                                data.chapterList.map((chapter) {
                                  return TreeViewItem(
                                    onInvoked: (item, reason) async {
                                      if (item.value != null) {
                                        onTapChapter(data, item.value);
                                        Navigator.pop(context);
                                      }
                                    },
                                    value: chapter,
                                    content: Text(
                                      "${chapter.number}장",
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                            children: [],
                          );
                        }).toList(),
                      ),
                    );
                  }),
            ),
          ],
        ),
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
        final currentData = state.selectedData!;
        final currentChapter = state.selectedChapter!;
        final verseList = currentChapter.verseList;
        return ScaffoldPage.withPadding(
          header: PageHeader(
            title: Center(
              child: Text(
                "${currentData.name} ${currentChapter.number}장",
              ),
            ),
            leading: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return chapterListDialog(
                      dataList: dataList,
                      currentChapter: currentChapter,
                      onTapChapter: (data, chapter) {
                        bloc.add(
                          BibleEventUpdatedChapter(data, chapter),
                        );
                      },
                    );
                  },
                );
              },
              icon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  FluentIcons.collapse_menu,
                  size: 24.0,
                ),
              ),
            ),
          ),
          content: Builder(builder: (context) {
            if (verseList.isEmpty) {
              return const BibleLoading();
            }
            return ListView(
              controller: state.scrollController,
              children: [
                for (int index = 0; index < verseList.length; index++)
                  VerseText(
                    index: index + 1,
                    text: verseList[index],
                  )
              ],
            );
          }),
        );
      },
    );
  }
}
