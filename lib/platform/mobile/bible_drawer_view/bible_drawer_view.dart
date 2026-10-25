import 'package:everydaybible/model/bible/bible_chapter.dart';
import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:everydaybible/platform/mobile/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

/// Chapter picker of the Bible reader listing every book and its chapters
/// so the user can jump to any chapter. Shown inside a side sheet.
class BibleDrawerView extends StatefulWidget {
  /// Creates the picker for [dataList] with [currentData] and
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

  Widget chapterWidget({
    required bool isSelected,
    required BibleChapter item,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: FBadge(
        variant: isSelected ? FBadgeVariant.primary : FBadgeVariant.secondary,
        child: Text('${item.number}장'),
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
        final searchController = state.drawerSearchController;
        final scrollController = state.drawerScrollController;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: FTextField(
                control: FTextFieldControl.managed(
                  controller: searchController,
                ),
                hint: 'search',
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: searchController,
                  builder: (context, value, _) {
                    final query = value.text;
                    return FAccordion(
                      children: [
                        for (final data in state.bibleDataList)
                          if (data.name.contains(query))
                            FAccordionItem(
                              initiallyExpanded: data == widget.currentData,
                              title: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(data.name),
                              ),
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: [
                                  for (final chapter in data.chapterList)
                                    chapterWidget(
                                      isSelected:
                                          chapter == state.selectedChapter,
                                      item: chapter,
                                      onTap: () {
                                        widget.onTapChapter(data, chapter);
                                        Navigator.pop(context);
                                      },
                                    ),
                                ],
                              ),
                            ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
