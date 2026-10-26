part of 'apk_install_repo.dart';

/// [ApkInstallRepo] implementation composing the download and installer
/// services.
class ApkInstallImpl extends ApkInstallRepo {
  /// Creates the repository from the platform services.
  ApkInstallImpl({
    ApkDownloadService? downloadService,
    ApkInstallerService? installerService,
  })  : _downloadService = downloadService ?? ApkDownloadService(),
        _installerService = installerService ?? ApkInstallerService();

  final ApkDownloadService _downloadService;

  final ApkInstallerService _installerService;

  StreamController<DownloadProgress>? _controller;

  @override
  Stream<DownloadProgress> download(String url) {
    final controller = StreamController<DownloadProgress>();
    _controller = controller;
    unawaited(_runDownload(url, controller));
    return controller.stream;
  }

  Future<void> _runDownload(
    String url,
    StreamController<DownloadProgress> controller,
  ) async {
    try {
      await _downloadService.download(url, (received, total) {
        if (!controller.isClosed) {
          controller.add(
            DownloadProgress(receivedBytes: received, totalBytes: total),
          );
        }
      });
      if (!controller.isClosed) {
        await controller.close();
      }
    } on Object catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
        await controller.close();
      }
    }
  }

  @override
  Future<Either<Failure, bool>> canRequestPackageInstalls() async {
    try {
      return Right(await _installerService.canRequestPackageInstalls());
    } on PlatformException catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> launchInstaller() async {
    final path = _downloadService.savedPath;
    if (path == null) {
      return const Left(Failure('No downloaded APK to install'));
    }
    try {
      final launched = await _installerService.launchInstaller(path);
      if (!launched) {
        return const Left(Failure('Installer launch failed'));
      }
      return const Right(unit);
    } on PlatformException catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> openInstallPermissionSettings() async {
    try {
      final opened = await _installerService.openInstallPermissionSettings();
      if (!opened) {
        return const Left(Failure('Could not open install settings'));
      }
      return const Right(unit);
    } on PlatformException catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  void cancelDownload() {
    unawaited(_controller?.close());
    _controller = null;
    _downloadService.cancel();
  }
}
