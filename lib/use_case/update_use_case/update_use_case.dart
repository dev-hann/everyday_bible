import 'package:everydaybible/model/failure.dart';
import 'package:everydaybible/model/update/download_progress.dart';
import 'package:everydaybible/model/update/update_check_result.dart';
import 'package:everydaybible/repo/apk_install_repo/apk_install_repo.dart';
import 'package:everydaybible/repo/update_repo/update_repo.dart';
import 'package:everydaybible/use_case/use_case.dart';
import 'package:fpdart/fpdart.dart';

/// Use case comparing versions and driving the APK download/install flow.
class UpdateUseCase extends UseCase<UpdateRepo> {
  /// Creates the update use case backed by the update repository and the
  /// APK install repository.
  UpdateUseCase(super.repo, this._apkRepo);

  final ApkInstallRepo _apkRepo;

  /// Checks GitHub for a release newer than [currentVersion].
  Future<Either<Failure, UpdateCheckResult>> checkForUpdate(
    String currentVersion,
  ) async {
    final result = await repo.getLatestRelease();
    return result.flatMap((release) {
      try {
        final isNewer = _isNewerVersion(release.version, currentVersion);
        return Right(
          UpdateCheckResult(
            type: isNewer
                ? UpdateStatusType.updateAvailable
                : UpdateStatusType.upToDate,
            release: release,
          ),
        );
      } on Object {
        return const Left(Failure('Invalid version format'));
      }
    });
  }

  /// Downloads the APK at [url], emitting progress and closing when done.
  Stream<DownloadProgress> download(String url) => _apkRepo.download(url);

  /// Whether the app may request package installs.
  Future<Either<Failure, bool>> canRequestPackageInstalls() =>
      _apkRepo.canRequestPackageInstalls();

  /// Opens the system installer for the downloaded APK.
  Future<Either<Failure, Unit>> launchInstaller() => _apkRepo.launchInstaller();

  /// Opens the system settings page for the install permission.
  Future<Either<Failure, Unit>> openInstallPermissionSettings() =>
      _apkRepo.openInstallPermissionSettings();

  /// Cancels the in-progress download.
  void cancelDownload() => _apkRepo.cancelDownload();

  bool _isNewerVersion(String remote, String current) {
    final remoteParts = _parseVersion(remote);
    final currentParts = _parseVersion(current);

    for (var i = 0; i < 3; i++) {
      final r = i < remoteParts.length ? remoteParts[i] : 0;
      final c = i < currentParts.length ? currentParts[i] : 0;
      if (r > c) return true;
      if (r < c) return false;
    }
    return false;
  }

  List<int> _parseVersion(String version) {
    final stripped = version.startsWith('v') || version.startsWith('V')
        ? version.substring(1)
        : version;
    final clean = stripped.split(RegExp('[-+]')).first;
    return clean.split('.').map(int.parse).toList();
  }
}
