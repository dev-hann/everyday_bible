part of bible_repo;

class BibleImpl extends BibleRepo {
  final BibleBox bibleBox = BibleBox();

  @override
  bool isExistDB() {
    return !bibleBox.isEmpty;
  }

  @override
  Future init() async {
    await bibleBox.openBox();
  }

  @override
  Future clearDB() {
    // TODO: implement clearDB
    throw UnimplementedError();
  }

  @override
  Future createDB() {
    // TODO: implement createDB
    throw UnimplementedError();
  }

  @override
  dynamic loadBible() {
    // TODO: implement loadBible
    throw UnimplementedError();
  }
}
