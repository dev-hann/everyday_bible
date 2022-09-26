library bible;

import 'package:equatable/equatable.dart';
import 'package:everydaybible/enum/bible_type.dart';
import 'package:everydaybible/models/hive_model.dart';

part 'bible_chapter.dart';

class Bible extends Equatable {
  Bible({
    required this.typeIndex,
    required this.title,
    required this.chpaterList,
  });
  final int typeIndex;
  final String title;
  final List<BibleChapter> chpaterList;

  @override
  List<Object?> get props => [
        typeIndex,
        title,
        chpaterList,
      ];

  factory Bible.fromMap(dynamic map) {
    final data = Map<String, dynamic>.from(map);
    return Bible(
      typeIndex: data["typeIndex"],
      title: data["title"],
      chpaterList: (data["chpaterList"] as List)
          .map((e) => BibleChapter.fromMap(e))
          .toList(),
    );
  }
}

extension BibleTypeString on String {
  BibleType? toBibleType() {
    switch (this) {
      case 'BibleType.Old':
        return BibleType.bc;
      case 'BibleType.New':
        return BibleType.ac;
      default:
        print("there's no such case $this (bible.dart)");
        return null;
    }
  }
}

class BibleOld extends Box {
  BibleOld({
    required this.type,
    required this.title,
    required this.chapterList,
  });

  BibleType type;
  String title;
  List<Chapter> chapterList;
  int get chapterListLength => chapterList.length;
  static List<BibleOld> fromListMap(List<dynamic> list) {
    List<BibleOld> _res = [];
    for (final bible in list) {
      _res.add(BibleOld.fromMap(Map<String, dynamic>.from(bible)));
    }
    return _res;
  }

  factory BibleOld.fromMap(Map<String, dynamic> map) {
    return new BibleOld(
      type: (map['type'] as String).toBibleType()!,
      title: map['title'] as String,
      chapterList: Chapter.toListChapter(map['chapterList']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'type': this.type.toString(),
      'title': this.title,
      'chapterList': Chapter.toListMap(this.chapterList),
    } as Map<String, dynamic>;
  }
}

class Chapter {
  Chapter({
    required this.index,
    required this.verseList,
  });

  int index;
  List<Verse> verseList;

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return new Chapter(
      index: map['index'] as int,
      verseList: Verse.toListVerse(map['verseList']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'index': this.index,
      'verseList': Verse.toListMap(this.verseList),
    } as Map<String, dynamic>;
  }

  static List<Map<String, dynamic>> toListMap(List<Chapter> list) {
    List<Map<String, dynamic>> _res = [];

    for (final chapter in list) {
      _res.add(chapter.toMap());
    }

    return _res;
  }

  static List<Chapter> toListChapter(List<dynamic> list) {
    List<Chapter> _res = [];

    for (final item in list) {
      _res.add(Chapter.fromMap(Map<String, dynamic>.from(item)));
    }

    return _res;
  }
}

class Verse {
  Verse({required this.verse});

  final String verse;

  factory Verse.fromMap(Map<String, dynamic> map) {
    return new Verse(
      verse: map['verse'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'verse': this.verse,
    } as Map<String, dynamic>;
  }

  static List<Map<String, dynamic>> toListMap(List<Verse> list) {
    List<Map<String, dynamic>> _res = [];
    for (final verse in list) {
      _res.add(verse.toMap());
    }
    return _res;
  }

  static List<Verse> toListVerse(List<dynamic> list) {
    List<Verse> _res = [];
    for (final item in list) {
      _res.add(Verse.fromMap(Map<String, dynamic>.from(item)));
    }
    return _res;
  }
}
