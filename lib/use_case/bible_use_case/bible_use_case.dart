import 'package:dartz/dartz.dart';
import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/models/failure.dart';
import 'package:everydaybible/use_case/use_case.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';

class BibleUseCase extends UseCase<BibleRepo> {
  BibleUseCase(super.repo);

  bool isExistBible() {
    return repo.isExistDB();
  }

  Future<Either<Failure, Bible>> loadBible() async {
    try {
      final res = await repo.loadBible();
      if (res == null) {
        return Left(Failure.emptyData());
      }
      return Right(Bible.fromMap(res));
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
