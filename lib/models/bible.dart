enum BibleType {
  Old,
  New,
}

class Bible {
  Bible({
    required this.type,
    required this.title,
    required this.chapterList,
  });

  BibleType type;
  String title;
  List<Chapter> chapterList;

  factory Bible.fromMap(Map<String, dynamic> map) {
    return new Bible(
      type: map['type'] as BibleType,
      title: map['title'] as String,
      chapterList:Chapter.toListChapter(map['chapterList']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'type': this.type,
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
  static List<Chapter> toListChapter(List<Map<String,dynamic>> list){
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

  static List<Verse> toListVerse(List<Map<String,dynamic>> list){
    List<Verse> _res=[];
    for(final item in list){
      _res.add(Verse.fromMap(Map<String,dynamic>.from(item)));
    }
    return _res;
  }
}
