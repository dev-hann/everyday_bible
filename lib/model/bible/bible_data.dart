import 'package:equatable/equatable.dart';

import 'package:everydaybible/model/bible/bible_chapter.dart';

/// A Bible book: its raw index key, display name, and chapter list.
class BibleData extends Equatable {
  /// Creates book data.
  const BibleData({
    required this.index,
    required this.name,
    required this.chapterList,
  });

  /// Builds [BibleData] from a raw map entry of the bundled Bible JSON.
  factory BibleData.fromMapEntry(MapEntry<String, dynamic> entry) {
    final key = entry.key;
    final value = entry.value as Map<String, dynamic>;
    final chapterRawList = List<Map<String, dynamic>>.from(
      value['chapterList'] as List,
    );
    final chapterList = <BibleChapter>[];
    for (var index = 0; index < chapterRawList.length; index++) {
      final data = chapterRawList[index];
      final item = BibleChapter(
        number: index + 1,
        verseList: List<String>.from(data['verseList'] as List),
      );
      chapterList.add(item);
    }
    return BibleData(
      index: key,
      name: value['name'] as String,
      chapterList: chapterList,
    );
  }

  /// Key of the book in the raw Bible JSON (book order index).
  final String index;

  /// Display name of the book.
  final String name;

  /// Chapters of the book, in order.
  final List<BibleChapter> chapterList;

  @override
  List<Object?> get props => [
        index,
        name,
        chapterList,
      ];
}
