import 'package:equatable/equatable.dart';

class BibleData extends Equatable {
  const BibleData({
    required this.title,
    required this.usfm,
    required this.chatperList,
  });
  final String title;
  final String usfm;
  final List<BibleChapter> chatperList;

  @override
  List<Object?> get props => [
        title,
        usfm,
        chatperList,
      ];

  factory BibleData.fromMap(Map<String, dynamic> map) {
    return BibleData(
      title: map['human'] as String,
      usfm: map['usfm'] as String,
      chatperList: List.from(map["chapters"])
          .map((e) => BibleChapter.fromMap(e))
          .toList(),
    );
  }
}

class BibleChapter extends Equatable {
  const BibleChapter({
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

  factory BibleChapter.fromMap(Map<String, dynamic> map) {
    return BibleChapter(
      usfm: map['usfm'] as String,
      number: map['human'] as String,
    );
  }
}
