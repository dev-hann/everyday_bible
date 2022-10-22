part of bible_repo;

class BibleImpl extends BibleRepo {
  final BibleDatabase bibleDB = BibleDatabase();

  @override
  bool isExistDB() {
    return !bibleDB.isEmpty;
  }

  @override
  Future init() async {
    // await bibleDB.init();
  }

  @override
  Future clearDB() {
    return bibleDB.deleteDB();
  }

  @override
  Future createDB() async {

  }

  @override
  dynamic loadBible() {
    return bibleDB.createDB();
  }
}
