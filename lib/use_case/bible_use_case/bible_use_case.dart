import 'package:dartz/dartz.dart';
import 'package:everydaybible/model/bible/bible_chapter.dart';
import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:everydaybible/model/bible/bible_verse.dart';
import 'package:everydaybible/model/failure.dart';
import 'package:everydaybible/use_case/use_case.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';

class BibleUseCase extends UseCase<BibleRepo> {
  BibleUseCase(super.repo);

  Future initDataBase() async {
    if (repo.databaseIsEmpty()) {
      await repo.initDataBase();
    }
  }

  Either<Failure, List<BibleData>> loadBibleDataList() {
    try {
      final list = repo.loadBibleDataList();
      return Right(
        list.map((e) => BibleData.fromMapEntry(e)).toList(),
      );
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @Deprecated("will be deprecated")
  Future<Either<Failure, List<BibleDataOld>>> requestBibleData() async {
    try {
      final res = await repo.requestBibleData();
      final list = List.from(res['books']);
      return Right(list.map((e) => BibleDataOld.fromMap(e)).toList());
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @Deprecated("will be deprecated")
  Future<Either<Failure, List<BibleVerse>>> requestVerseList(
      BibleChapterOld chapter) async {
    try {
      final res = await repo.requestVerseList(chapter.usfm);
      final List<BibleVerse> list = [];
      int index = 1;
      for (final item in res) {
        if (item.trim().isNotEmpty) {
          list.add(
            BibleVerse(index: index, text: item),
          );
          index++;
        }
      }
      return Right(list);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
