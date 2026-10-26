import 'package:dio/dio.dart';
import 'package:everydaybible/model/failure.dart';
import 'package:everydaybible/model/update/app_release.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:fpdart/fpdart.dart';

part 'update_impl.dart';

/// Repository reading the app's published GitHub releases.
abstract class UpdateRepo extends Repo {
  /// Fetches the latest published release.
  ///
  /// Returns [Left] with a [Failure] on network or parse errors.
  Future<Either<Failure, AppRelease>> getLatestRelease();
}
