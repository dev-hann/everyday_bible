import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:everydaybible/model/update/app_release.dart';
import 'package:everydaybible/model/update/download_progress.dart';
import 'package:everydaybible/use_case/update_use_case/update_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'update_event.dart';
part 'update_state.dart';

/// Drives the settings version section: release check, APK download, and
/// installer hand-off.
class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  /// Creates the bloc.
  ///
  /// [resolveCurrentVersion] defaults to the installed package version and
  /// exists so tests can inject a fixed value.
  UpdateBloc({
    required UpdateUseCase useCase,
    Future<String> Function()? resolveCurrentVersion,
  })  : _useCase = useCase,
        _resolveCurrentVersion =
            resolveCurrentVersion ?? _platformCurrentVersion,
        super(const UpdateState()) {
    on<UpdateEventInited>(_onInited);
    on<UpdateEventRetryTapped>(_onRetryTapped);
    on<UpdateEventDownloadTapped>(_onDownloadTapped);
    on<UpdateEventDownloadRetried>(_onDownloadRetried);
    on<UpdateEventDownloadCanceled>(_onDownloadCanceled);
    on<UpdateEventDownloadProgressed>(_onDownloadProgressed);
    on<UpdateEventDownloadFailed>(_onDownloadFailed);
    on<UpdateEventDownloadSucceeded>(_onDownloadSucceeded);
    on<UpdateEventInstallTapped>(_onInstallTapped);
    on<UpdateEventPermissionSettingsTapped>(
      _onPermissionSettingsTapped,
    );
  }

  final UpdateUseCase _useCase;

  final Future<String> Function() _resolveCurrentVersion;

  StreamSubscription<DownloadProgress>? _downloadSub;

  bool _cancelled = false;

  static Future<String> _platformCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  Future<void> _onInited(
    UpdateEventInited event,
    Emitter<UpdateState> emit,
  ) async {
    final current = await _resolveCurrentVersion();
    emit(
      state.copyWith(
        status: UpdateViewStatus.checking,
        currentVersion: current,
      ),
    );
    await _check(emit);
  }

  Future<void> _onRetryTapped(
    UpdateEventRetryTapped event,
    Emitter<UpdateState> emit,
  ) async {
    emit(state.copyWith(status: UpdateViewStatus.checking));
    await _check(emit);
  }

  Future<void> _check(Emitter<UpdateState> emit) async {
    final current = state.currentVersion;
    if (current == null) {
      emit(state.copyWith(status: UpdateViewStatus.failure));
      return;
    }
    final result = await _useCase.checkForUpdate(current);
    result.fold(
      (failure) => emit(state.copyWith(status: UpdateViewStatus.failure)),
      (check) => emit(
        state.copyWith(
          status: check.isUpdateAvailable
              ? UpdateViewStatus.available
              : UpdateViewStatus.upToDate,
          release: check.release,
        ),
      ),
    );
  }

  Future<void> _onDownloadTapped(
    UpdateEventDownloadTapped event,
    Emitter<UpdateState> emit,
  ) async {
    await _startDownload(emit);
  }

  Future<void> _onDownloadRetried(
    UpdateEventDownloadRetried event,
    Emitter<UpdateState> emit,
  ) async {
    await _startDownload(emit);
  }

  Future<void> _startDownload(Emitter<UpdateState> emit) async {
    final url = state.release?.downloadUrl;
    if (url == null) return;

    _cancelled = false;
    emit(
      state.copyWith(
        status: UpdateViewStatus.downloading,
        progress: const DownloadProgress(receivedBytes: 0, totalBytes: 0),
      ),
    );

    await _downloadSub?.cancel();
    _downloadSub = _useCase.download(url).listen(
          (progress) => add(UpdateEventDownloadProgressed(progress)),
          onError: (Object _) => add(const UpdateEventDownloadFailed()),
          onDone: () => add(const UpdateEventDownloadSucceeded()),
          // Errors close the subscription so onDone never follows an error.
          cancelOnError: true,
        );
  }

  Future<void> _onDownloadCanceled(
    UpdateEventDownloadCanceled event,
    Emitter<UpdateState> emit,
  ) async {
    _cancelled = true;
    await _downloadSub?.cancel();
    _downloadSub = null;
    _useCase.cancelDownload();
    emit(state.copyWith(status: UpdateViewStatus.available));
  }

  Future<void> _onDownloadProgressed(
    UpdateEventDownloadProgressed event,
    Emitter<UpdateState> emit,
  ) async {
    if (_cancelled) return;
    emit(
      state.copyWith(
        status: UpdateViewStatus.downloading,
        progress: event.progress,
      ),
    );
  }

  Future<void> _onDownloadFailed(
    UpdateEventDownloadFailed event,
    Emitter<UpdateState> emit,
  ) async {
    if (_cancelled) return;
    emit(state.copyWith(status: UpdateViewStatus.downloadFailure));
  }

  Future<void> _onDownloadSucceeded(
    UpdateEventDownloadSucceeded event,
    Emitter<UpdateState> emit,
  ) async {
    if (_cancelled) return;
    emit(state.copyWith(status: UpdateViewStatus.readyToInstall));
    await _tryLaunchInstaller(emit);
  }

  Future<void> _onInstallTapped(
    UpdateEventInstallTapped event,
    Emitter<UpdateState> emit,
  ) async {
    await _tryLaunchInstaller(emit);
  }

  Future<void> _tryLaunchInstaller(Emitter<UpdateState> emit) async {
    final canInstall = (await _useCase.canRequestPackageInstalls())
        .getOrElse((failure) => false);
    if (!canInstall) {
      emit(
        state.copyWith(status: UpdateViewStatus.installPermissionRequired),
      );
      return;
    }
    // The installer intent is shown. When the user cancels it, the state
    // stays readyToInstall so they can retry without re-downloading.
    final result = await _useCase.launchInstaller();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: UpdateViewStatus.downloadFailure)),
      (_) => emit(state.copyWith(status: UpdateViewStatus.readyToInstall)),
    );
  }

  Future<void> _onPermissionSettingsTapped(
    UpdateEventPermissionSettingsTapped event,
    Emitter<UpdateState> emit,
  ) async {
    await _useCase.openInstallPermissionSettings();
    // The banner stays in installPermissionRequired until the user returns
    // and taps install again.
  }

  @override
  Future<void> close() async {
    await _downloadSub?.cancel();
    await super.close();
  }
}
