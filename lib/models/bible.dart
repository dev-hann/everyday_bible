import 'package:everydaybible/models/hive_model.dart';

enum BibleType {
  Old,
  New,
}

extension BibleTypeString on String{
  BibleType? toBibleType(){
    switch(this){
      case 'BibleType.Old':
        return BibleType.Old;
      case 'BibleType.New':
        return BibleType.New;
      default:
        print("there's no such case $this (bible.dart)");
        return null;
    }
  }
}

class Bible extends HiveModel{
  Bible({
    required this.type,
    required this.title,
    required this.chapterList,
  });

  BibleType type;
  String title;
  List<Chapter> chapterList;
  int get chapterListLength => chapterList.length;
  static List<Bible> fromListMap(List<dynamic> list){
    List<Bible> _res=[];
    for(final bible in list ){
      _res.add(Bible.fromMap(Map<String,dynamic>.from(bible)));
    }
    return _res;
  }

  factory Bible.fromMap(Map<String, dynamic> map) {
    return new Bible(
      type: (map['type'] as String).toBibleType()!,
      title: map['title'] as String,
      chapterList:Chapter.toListChapter(map['chapterList']),
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

  static List<Map<String,dynamic>> toListMap(List<Chapter> list){
    List<Map<String,dynamic>> _res=[];

    for(final chapter in list){
      _res.add(chapter.toMap());
    }

    return _res;


  }
  static List<Chapter> toListChapter(List<dynamic> list){
    List<Chapter> _res=[];

    for(final item in list){
      _res.add(Chapter.fromMap(Map<String,dynamic>.from(item)));
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

  static List<Verse> toListVerse(List<dynamic> list){
    List<Verse> _res=[];
    for(final item in list){
      _res.add(Verse.fromMap(Map<String,dynamic>.from(item)));
    }
    return _res;
  }
}
