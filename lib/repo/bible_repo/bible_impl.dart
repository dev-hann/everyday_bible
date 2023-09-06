part of bible_repo;

class BibleImpl extends BibleRepo {
  final BibleService service = BibleService();

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
  Future requestBibleData() async {
    final res = await service.requestBibleData();
    return res.data;
  }

  @override
  Future<List<String>> requestVerseList(String usfm) async {
    final res = await service.requestVerseList(usfm);
    final content = res.data["pageProps"]["chapterInfo"]["content"];
    final document = parse(content);

    return List.from(
      document.getElementsByClassName("content").map((e) => e.text),
    );
  }

  @override
  List<MapEntry<String, dynamic>> loadBibleDataList() {
    return tmpDB.entries.toList();
  }
}
