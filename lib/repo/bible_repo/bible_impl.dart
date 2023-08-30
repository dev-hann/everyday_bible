part of bible_repo;

class BibleImpl extends BibleRepo {
  final BibleService service = BibleService();
  @override
  Future requestBibleData() {
    return service.requestBibleData();
  }
}
