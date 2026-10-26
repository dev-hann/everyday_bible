import 'dart:async';

import 'package:everydaybible/model/failure.dart';
import 'package:everydaybible/model/update/download_progress.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:everydaybible/service/apk_download_service.dart';
import 'package:everydaybible/service/apk_installer_service.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';

part 'apk_install_impl.dart';

/// Repository downloading update APKs and launching the system installer.
abstract class ApkInstallRepo extends Repo {
  /// Downloads [url], emitting [DownloadProgress] and closing when done.
  ///
  /// The stream errors on download failure or cancellation.
  Stream<DownloadProgress> download(String url);

  /// Whether the app holds the Android install-unknown-apps permission.
  Future<Either<Failure, bool>> canRequestPackageInstalls();

  /// Opens the system installer for the downloaded APK.
  Future<Either<Failure, Unit>> launchInstaller();

  /// Opens the system settings page for the install permission.
  Future<Either<Failure, Unit>> openInstallPermissionSettings();

  /// Cancels the in-progress download and removes the partial file.
  void cancelDownload();
}
