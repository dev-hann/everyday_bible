part of bible;

class BibleChapter extends Equatable {
  BibleChapter(this.index, this.verseList);

  final int index;
  final List<String> verseList;

  @override
  List<Object?> get props => [index, verseList];

  factory BibleChapter.fromMap(dynamic map) {
    final data = Map<String, dynamic>.from(map);
    return BibleChapter(
      data["index"],
      data["verseList"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "index": index,
      "verseList": verseList,
    };
  }
}
