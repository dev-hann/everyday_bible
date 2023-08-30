import 'package:dartz/dartz.dart';
import 'package:everydaybible/models/bible/bible_data.dart';
import 'package:everydaybible/models/failure.dart';
import 'package:everydaybible/use_case/use_case.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';

class BibleUseCase extends UseCase<BibleRepo> {
  BibleUseCase(super.repo);

  Future<Either<Failure, List<BibleData>>> requestBibleData() async {
    try {
      final res = await repo.requestBibleData();
      final list = List.from(res['books']);
      return Right(list.map((e) => BibleData.fromMap(e)).toList());
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
