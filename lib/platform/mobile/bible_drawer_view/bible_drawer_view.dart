import 'package:everydaybible/model/bible/bible_chapter.dart';
import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:everydaybible/platform/mobile/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Drawer of the Bible reader listing every book and its chapters so the
/// user can jump to any chapter.
class BibleDrawerView extends StatefulWidget {
  /// Creates the drawer for [dataList] with [currentData] and
  /// [currentChapter] highlighted.
  const BibleDrawerView({
    required this.dataList,
    required this.currentData,
    required this.currentChapter,
    required this.onTapChapter,
    super.key,
  });

  /// The book currently shown in the reader.
  final BibleData currentData;

  /// The chapter currently shown in the reader.
  final BibleChapter currentChapter;

  /// All books of the Bible.
  final List<BibleData> dataList;

  /// Called when the user taps a chapter of a book.
  final void Function(BibleData data, BibleChapter chapter) onTapChapter;

  @override
  State<BibleDrawerView> createState() => _BibleDrawerViewState();
}

class _BibleDrawerViewState extends State<BibleDrawerView> {
  BibleBloc get bloc => BlocProvider.of(context);

  Widget searchTextfield({
    required TextEditingController searchController,
  }) {
    return TextField(
      controller: searchController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
      ),
    );
  }

  Widget chapterWidget({
    required bool isSelected,
    required BibleChapter item,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Center(
            child: Text('${item.number}장'),
          ),
        ),
      ),
    );
  }

  Widget capterList({
    required TextEditingController searchController,
    required BibleData data,
    required bool Function(BibleChapter chapter) isSelected,
    required void Function(BibleChapter chapter) onTapChapter,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: searchController,
      builder: (context, value, _) {
        final title = data.name;
        final query = value.text;
        if (!title.contains(query)) {
          return const SizedBox();
        }
        return ExpansionTile(
          initiallyExpanded: data == widget.currentData,
          tilePadding: EdgeInsets.zero,
          title: Row(
            children: [
              Text(title),
              const SizedBox(width: 4),
              const Expanded(child: Divider()),
            ],
          ),
          children: data.chapterList
              .map(
                (item) => GestureDetector(
                  onTap: () {
                    onTapChapter(item);
                  },
                  child: chapterWidget(
                    isSelected: isSelected(item),
                    item: item,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      child: SafeArea(
        child: BlocBuilder<BibleBloc, BibleState>(
          builder: (context, state) {
            final status = state.status;
            switch (status) {
              case BibleViewStatus.init:
                return const BibleLoading();
              case BibleViewStatus.loading:
              case BibleViewStatus.failure:
              case BibleViewStatus.success:
            }
            final searchController = state.drawerSearchController;
            final scrollController = state.drawerScrollController;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: searchTextfield(
                    searchController: searchController,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: state.bibleDataList.map((data) {
                        return ValueListenableBuilder<TextEditingValue>(
                          valueListenable: searchController,
                          builder: (context, value, _) {
                            final title = data.name;
                            final query = value.text;
                            if (!title.contains(query)) {
                              return const SizedBox();
                            }
                            return ExpansionTile(
                              initiallyExpanded: data == widget.currentData,
                              tilePadding: EdgeInsets.zero,
                              title: Row(
                                // key: state.scrollKeyMap[data],
                                children: [
                                  Text(title),
                                  const SizedBox(width: 4),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                              children: data.chapterList
                                  .map(
                                    (item) => GestureDetector(
                                      onTap: () {
                                        widget.onTapChapter(data, item);
                                        Navigator.pop(context);
                                      },
                                      child: chapterWidget(
                                        isSelected:
                                            item == state.selectedChapter,
                                        item: item,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
