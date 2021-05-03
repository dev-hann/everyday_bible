import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/views/bible_views/bible_text_selection_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

///[Todo] scroll to index has bug..
class BibleChapterListView extends StatefulWidget {
  const BibleChapterListView({
    required this.chapterList,
    required this.initIndex,
  });

  final List<Chapter> chapterList;
  final int initIndex;

  @override
  _BibleChapterListViewState createState() => _BibleChapterListViewState();
}

class _BibleChapterListViewState extends State<BibleChapterListView>  {
  final AutoScrollController _controller=AutoScrollController(
    viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, 0),
  );


  ///[todo] refactoring!!
  void didUpdateWidget(covariant BibleChapterListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initIndex != widget.initIndex) {
      _controller.scrollToIndex(
        widget.initIndex,
        preferPosition: AutoScrollPosition.begin,
        duration: Duration(milliseconds: 100),
      );
    }
  }

  Widget chapterCard(Chapter chapter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${chapter.index}장",
                style: Get.textTheme.bodyText2!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: Divider(
              color: Colors.white,
            ))
          ],
        ),
        SelectableText.rich(
          TextSpan(
            children: [
              for (int index = 0;
                  index < chapter.verseList.length;
                  index++) ...[
                TextSpan(text: " ${index + 1} "),
                TextSpan(text: chapter.verseList[index].verse)
              ]
            ],
          ),
          style: TextStyle(height: 1.5),
          selectionControls: BibleTextSelectionControls(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
          controller: _controller,
          itemCount: widget.chapterList.length,
          itemBuilder: (_, index) {
            return AutoScrollTag(
              index: index,
              key: ValueKey(index),
              controller: _controller,
              child: chapterCard(
                widget.chapterList[index],
              ),
            );
          },
      ),
    );
  }

}
