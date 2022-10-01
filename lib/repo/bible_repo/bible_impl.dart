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
    return bibleBox.clearBox();
  }

  @override
  Future createDB()async {
    
  }

  @override
  dynamic loadBible() {
    return bibleBox.loadBible();
  }
}
