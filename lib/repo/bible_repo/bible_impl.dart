part of 'bible_repo.dart';

/// [BibleRepo] implementation keeping the parsed asset data in memory.
class BibleImpl extends BibleRepo {
  /// Parsed contents of `bible.json` keyed by book and chapter.
  Map<String, dynamic> tmpDB = {};

  @override
  bool databaseIsEmpty() {
    return tmpDB.isEmpty;
  }

  @override
  Future<void> initDataBase() async {
    final data = await rootBundle.loadString('./assets/data/bible.json');
    tmpDB = json.decode(data) as Map<String, dynamic>;
  }

  @override
  List<MapEntry<String, dynamic>> loadBibleDataList() {
    return tmpDB.entries.toList();
  }
}
