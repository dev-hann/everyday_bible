import 'package:dartz/dartz.dart';
import 'package:everydaybible/model/bible/bible_data.dart';
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
}
