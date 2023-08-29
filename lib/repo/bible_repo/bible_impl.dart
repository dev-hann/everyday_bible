part of bible_repo;

class BibleImpl extends BibleRepo {
  // final BibleDatabase bibleDB = BibleDatabase();

  @override
  bool isExistDB() {
    throw Exception();
    // return !bibleDB.isEmpty;
  }

  @override
  Future init() async {
    // await bibleDB.init();
  }

  @override
  Future clearDB() {
    throw Exception();
    // return bibleDB.deleteDB();
  }

  @override
  Future createDB() async {}

  @override
  dynamic loadBible() {
    throw Exception();
    // return bibleDB.createDB();
  }
}
