import 'package:dartz/dartz.dart';
import 'package:everydaybible/model/failure.dart';
import 'package:everydaybible/model/quite_time/quite_time.dart';
import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:everydaybible/model/quite_time/quite_time_gospel.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:everydaybible/use_case/use_case.dart';

class QuiteTimeUseCase extends UseCase<QuiteTimeRepo> {
  QuiteTimeUseCase(super.repo);

  Future<Either<Failure, QuiteTime>> requestQuiteTime(DateTime dateTime) async {
    try {
      final data =
          QuiteTimeData.fromMap(await repo.requestQuiteTimeData(dateTime));
      final list =
          List.from(await repo.requestQuiteTimeBody(dateTime)).map((e) {
        return QuiteTimeGospel.fromMap(e);
      }).toList();
      return Right(QuiteTime(
        data: data,
        gospelList: list,
      ));
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
