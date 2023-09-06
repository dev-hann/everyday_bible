import 'package:everydaybible/model/bible/bible_chapter.dart';
import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:flutter/material.dart';

class BibleDrawer extends StatelessWidget {
  BibleDrawer({
    super.key,
    required this.dataList,
    required this.currentChapter,
    required this.onTapChapter,
  });
  final BibleChapter? currentChapter;
  final List<BibleData> dataList;
  final Function(BibleChapter chapter) onTapChapter;
  final TextEditingController searchController = TextEditingController();
  Widget searchTextfield() {
    return TextField(
      controller: searchController,
    );
  }

  Widget chapterWidget({
    required bool isSelected,
    required BibleChapter item,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white10,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Center(child: Text("${item.number}장")),
        ),
      ),
    );
  }

  Widget capterList({
    required BibleData data,
    required bool Function(BibleChapter chapter) isSelected,
    required Function(BibleChapter chapter) onTapChapter,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: searchController,
      builder: (context, value, _) {
        final title = data.name;
        if (!title.contains(value.text)) {
          return const SizedBox();
        }
        return ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Row(
            children: [
              Text(title),
              const SizedBox(width: 4.0),
              const Expanded(child: Divider()),
            ],
          ),
          children: data.chapterList
              .map((item) => GestureDetector(
                    onTap: () {
                      onTapChapter(item);
                    },
                    child: chapterWidget(
                      isSelected: isSelected(item),
                      item: item,
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: kToolbarHeight,
        ),
        children: [
          searchTextfield(),
          for (final data in dataList)
            capterList(
              data: data,
              isSelected: (chapter) {
                return currentChapter == chapter;
              },
              onTapChapter: (chapter) {
                onTapChapter(chapter);
                Navigator.pop(context);
              },
            )
        ],
      ),
    );
  }
}
