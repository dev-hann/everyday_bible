import 'package:everydaybible/models/bible/bible_chapter.dart';
import 'package:everydaybible/models/bible/bible_data.dart';
import 'package:flutter/material.dart';

class BibleDrawer extends StatelessWidget {
  const BibleDrawer({
    super.key,
    required this.dataList,
    required this.currentChapter,
    required this.onTapChapter,
  });
  final BibleChapter? currentChapter;
  final List<BibleData> dataList;
  final Function(BibleChapter chapter) onTapChapter;

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
          Row(
            children: [
              Text(data.title),
              const SizedBox(width: 4.0),
              const Expanded(child: Divider()),
            ],
          ),
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
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: kToolbarHeight,
        ),
        children: dataList.map((e) {
          return capterList(
            data: e,
            isSelected: (chapter) {
              return currentChapter == chapter;
            },
            onTapChapter: (chapter) {
              onTapChapter(chapter);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
