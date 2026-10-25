import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:everydaybible/model/failure.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/use_case/use_case.dart';
import 'package:fpdart/fpdart.dart';

/// Use case initializing the Bible database and loading its contents.
class BibleUseCase extends UseCase<BibleRepo> {
  /// Creates a Bible use case backed by [repo].
  BibleUseCase(super.repo);

  /// Loads `bible.json` into the database when it is still empty.
  Future<void> initDataBase() async {
    if (repo.databaseIsEmpty()) {
      await repo.initDataBase();
    }
  }

  /// Loads every Bible entry; [Left] carries the [Failure] on a parse error.
  Either<Failure, List<BibleData>> loadBibleDataList() {
    try {
      final list = repo.loadBibleDataList();
      return Right(
        list.map(BibleData.fromMapEntry).toList(),
      );
    } on Object catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
