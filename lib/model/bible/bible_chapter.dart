import 'package:equatable/equatable.dart';

class BibleChapter extends Equatable {
  const BibleChapter({
    required this.number,
    required this.verseList,
  });
  final int number;
  final List<String> verseList;

  @override
  List<Object?> get props => [
        number,
        verseList,
      ];
}

class BibleChapterOld extends Equatable {
  const BibleChapterOld({
    required this.usfm,
    required this.number,
  });
  final String usfm;
  final String number;

  @override
  List<Object?> get props => [
        usfm,
        number,
      ];

  factory BibleChapterOld.fromMap(Map<String, dynamic> map) {
    return BibleChapterOld(
      usfm: map['usfm'] as String,
      number: map['human'] as String,
    );
  }
}
