part of 'update_repo.dart';

/// [UpdateRepo] implementation reading GitHub's public releases API.
class UpdateImpl extends UpdateRepo {
  /// Creates the repository.
  ///
  /// [dio] defaults to a client pointed at the GitHub API of this app's
  /// repository.
  UpdateImpl({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.github.com',
                headers: {'Accept': 'application/vnd.github+json'},
              ),
            );

  final Dio _dio;

  @override
  Future<Either<Failure, AppRelease>> getLatestRelease() async {
    try {
      final response = await _dio.get<dynamic>(
        '/repos/dev-hann/everyday_bible/releases/latest',
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        return const Left(Failure('Invalid release payload'));
      }
      final release = AppRelease.fromJson(data);
      if (release.version.isEmpty || release.htmlUrl.isEmpty) {
        return const Left(Failure('Failed to parse release info'));
      }
      return Right(release);
    } on DioException catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
