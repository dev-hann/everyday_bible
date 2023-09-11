part of bible_repo;

class BibleImpl extends BibleRepo {
  Map<String, dynamic> tmpDB = {};

  @override
  bool databaseIsEmpty() {
    return tmpDB.isEmpty;
  }

  @override
  Future initDataBase() async {
    final data = await rootBundle.loadString("./assets/data/bible.json");
    tmpDB = json.decode(data);
  }

  @override
  List<MapEntry<String, dynamic>> loadBibleDataList() {
    return tmpDB.entries.toList();
  }
}
