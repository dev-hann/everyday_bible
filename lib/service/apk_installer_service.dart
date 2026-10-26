import 'package:flutter/services.dart';

/// Bridges to the Android package installer through the `apk_installer`
/// platform channel.
class ApkInstallerService {
  /// Creates the service bound to [methodChannel].
  ApkInstallerService({MethodChannel? methodChannel})
      : _methodChannel = methodChannel ?? const MethodChannel('apk_installer');

  final MethodChannel _methodChannel;

  /// Opens the system installer for the APK at [filePath].
  ///
  /// Returns whether the installer intent was actually started.
  Future<bool> launchInstaller(String filePath) async {
    final result = await _methodChannel.invokeMethod<bool>(
      'launchInstaller',
      {'path': filePath},
    );
    return result ?? false;
  }

  /// Whether the app may request installing packages (Android O+ unknown
  /// sources permission); always true on older Android versions.
  Future<bool> canRequestPackageInstalls() async {
    final result = await _methodChannel.invokeMethod<bool>(
      'canRequestPackageInstalls',
    );
    return result ?? false;
  }

  /// Opens the system page where the user grants the install permission.
  Future<bool> openInstallPermissionSettings() async {
    final result = await _methodChannel.invokeMethod<bool>(
      'openInstallPermissionSettings',
    );
    return result ?? false;
  }
}
