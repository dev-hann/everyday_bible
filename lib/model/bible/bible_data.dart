import 'package:equatable/equatable.dart';

import 'package:everydaybible/model/bible/bible_chapter.dart';

class BibleData extends Equatable {
  const BibleData({
    required this.index,
    required this.name,
    required this.chapterList,
  });
  final String index;
  final String name;
  final List<BibleChapter> chapterList;

  @override
  List<Object?> get props => [
        index,
        name,
        chapterList,
      ];

  factory BibleData.fromMapEntry(MapEntry<String, dynamic> entry) {
    final key = entry.key;
    final value = entry.value;
    final chapterRawList = List.from(value['chapterList']);
    final chapterList = <BibleChapter>[];
    for (int index = 0; index < chapterRawList.length; index++) {
      final data = chapterRawList[index];
      final item = BibleChapter(
        number: index + 1,
        verseList: List<String>.from(data["verseList"]),
      );
      chapterList.add(item);
    }
    return BibleData(
      index: key,
      name: value["name"],
      chapterList: chapterList,
    );
  }
}
