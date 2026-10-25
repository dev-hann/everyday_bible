import 'package:everydaybible/model/failure.dart';
import 'package:everydaybible/model/quite_time/quite_time.dart';
import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:everydaybible/model/quite_time/quite_time_gospel.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:everydaybible/use_case/use_case.dart';
import 'package:fpdart/fpdart.dart';

/// Use case fetching and parsing Quiet Time data via [QuiteTimeRepo].
class QuiteTimeUseCase extends UseCase<QuiteTimeRepo> {
  /// Creates a Quiet Time use case backed by [repo].
  QuiteTimeUseCase(super.repo);

  /// Fetches the Quiet Time metadata for [dateTime]; [Left] carries the
  /// [Failure] when the request or parsing fails.
  Future<Either<Failure, QuiteTimeData>> requestQuiteTimeData(
    DateTime dateTime,
  ) async {
    try {
      final data = QuiteTimeData.fromMap(
        await repo.requestQuiteTimeData(dateTime) as Map<String, dynamic>,
      );
      return Right(data);
    } on Object catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  /// Fetches the metadata plus the gospel verse list for [dateTime]; [Left]
  /// carries the [Failure] when any request or parsing fails.
  Future<Either<Failure, QuiteTime>> requestQuiteTime(DateTime dateTime) async {
    try {
      final data = QuiteTimeData.fromMap(
        await repo.requestQuiteTimeData(dateTime) as Map<String, dynamic>,
      );
      final body = await repo.requestQuiteTimeBody(dateTime) as List<dynamic>;
      final list = body
          .map((e) => QuiteTimeGospel.fromMap(e as Map<String, dynamic>))
          .toList();
      return Right(
        QuiteTime(
          data: data,
          gospelList: list,
        ),
      );
    } on Object catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
