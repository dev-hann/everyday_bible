part of bible_repo;

class BibleImpl extends BibleRepo {
  final BibleService service = BibleService();
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
}
