import 'dart:async';

import 'package:everydaybible/model/failure.dart';
import 'package:everydaybible/model/update/app_release.dart';
import 'package:everydaybible/model/update/download_progress.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/update_bloc.dart';
import 'package:everydaybible/repo/apk_install_repo/apk_install_repo.dart';
import 'package:everydaybible/repo/update_repo/update_repo.dart';
import 'package:everydaybible/use_case/update_use_case/update_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockUpdateRepo extends Mock implements UpdateRepo {}

class _MockApkInstallRepo extends Mock implements ApkInstallRepo {}

AppRelease _release({String version = '3.1.0', String? downloadUrl}) =>
    AppRelease(
      version: version,
      htmlUrl: 'https://github.com/dev-hann/everyday_bible/releases/latest',
      downloadUrl: downloadUrl ?? 'https://github.com/dev-hann/a.apk',
    );

UpdateBloc _bloc(UpdateRepo updateRepo, ApkInstallRepo apkRepo) => UpdateBloc(
      useCase: UpdateUseCase(updateRepo, apkRepo),
      resolveCurrentVersion: () async => '3.0.0',
    );

void main() {
  late _MockUpdateRepo updateRepo;
  late _MockApkInstallRepo apkRepo;

  setUp(() {
    updateRepo = _MockUpdateRepo();
    apkRepo = _MockApkInstallRepo();
  });

  group('UpdateBloc', () {
    test('Inited checks the latest release and reports it available', () async {
      when(() => updateRepo.getLatestRelease())
          .thenAnswer((_) async => Right(_release()));

      final bloc = _bloc(updateRepo, apkRepo);
      final states = <UpdateState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const UpdateEventInited());

      await bloc.stream.firstWhere(
        (state) => state.status == UpdateViewStatus.available,
      );
      await sub.cancel();
      await bloc.close();

      expect(bloc.state.currentVersion, '3.0.0');
      expect(bloc.state.release?.version, '3.1.0');
      expect(states.first.status, UpdateViewStatus.checking);
    });

    test('Inited reports up to date for the same version', () async {
      when(() => updateRepo.getLatestRelease())
          .thenAnswer((_) async => Right(_release(version: '3.0.0')));

      final bloc = _bloc(updateRepo, apkRepo)..add(const UpdateEventInited());

      await bloc.stream.firstWhere(
        (state) => state.status == UpdateViewStatus.upToDate,
      );
      await bloc.close();
    });

    test('Inited maps a repository failure to the failure status', () async {
      when(() => updateRepo.getLatestRelease())
          .thenAnswer((_) async => const Left(Failure('offline')));

      final bloc = _bloc(updateRepo, apkRepo)..add(const UpdateEventInited());

      await bloc.stream.firstWhere(
        (state) => state.status == UpdateViewStatus.failure,
      );
      await bloc.close();
    });

    test(
      'DownloadTapped progresses to readyToInstall and launches the installer',
      () async {
        when(() => updateRepo.getLatestRelease())
            .thenAnswer((_) async => Right(_release()));
        when(() => apkRepo.download(any())).thenAnswer(
          (_) => Stream<DownloadProgress>.fromIterable([
            const DownloadProgress(receivedBytes: 1, totalBytes: 2),
            const DownloadProgress(receivedBytes: 2, totalBytes: 2),
          ]),
        );
        when(() => apkRepo.canRequestPackageInstalls())
            .thenAnswer((_) async => const Right(true));
        when(() => apkRepo.launchInstaller())
            .thenAnswer((_) async => const Right(unit));

        final bloc = _bloc(updateRepo, apkRepo)..add(const UpdateEventInited());

        await bloc.stream.firstWhere(
          (state) => state.status == UpdateViewStatus.available,
        );
        bloc.add(const UpdateEventDownloadTapped());

        await bloc.stream.firstWhere(
          (state) => state.status == UpdateViewStatus.readyToInstall,
        );
        await bloc.close();

        verify(() => apkRepo.launchInstaller()).called(1);
      },
    );

    test('DownloadTapped requires the install permission when not granted',
        () async {
      when(() => updateRepo.getLatestRelease())
          .thenAnswer((_) async => Right(_release()));
      when(() => apkRepo.download(any())).thenAnswer(
        (_) => Stream<DownloadProgress>.fromIterable([
          const DownloadProgress(receivedBytes: 1, totalBytes: 1),
        ]),
      );
      when(() => apkRepo.canRequestPackageInstalls())
          .thenAnswer((_) async => const Right(false));

      final bloc = _bloc(updateRepo, apkRepo)..add(const UpdateEventInited());

      await bloc.stream.firstWhere(
        (state) => state.status == UpdateViewStatus.available,
      );
      bloc.add(const UpdateEventDownloadTapped());

      await bloc.stream.firstWhere(
        (state) => state.status == UpdateViewStatus.installPermissionRequired,
      );
      await bloc.close();

      verifyNever(() => apkRepo.launchInstaller());
    });

    test('DownloadTapped maps a stream error to downloadFailure', () async {
      when(() => updateRepo.getLatestRelease())
          .thenAnswer((_) async => Right(_release()));
      when(() => apkRepo.download(any())).thenAnswer(
        (_) async* {
          yield const DownloadProgress(receivedBytes: 1, totalBytes: 0);
          throw Exception('network');
        },
      );

      final bloc = _bloc(updateRepo, apkRepo)..add(const UpdateEventInited());

      await bloc.stream.firstWhere(
        (state) => state.status == UpdateViewStatus.available,
      );
      bloc.add(const UpdateEventDownloadTapped());

      await bloc.stream.firstWhere(
        (state) => state.status == UpdateViewStatus.downloadFailure,
      );
      await bloc.close();
    });

    test(
      'DownloadCanceled cancels the download and returns to available',
      () async {
        when(() => updateRepo.getLatestRelease())
            .thenAnswer((_) async => Right(_release()));
        final controller = StreamController<DownloadProgress>();
        addTearDown(controller.close);
        when(() => apkRepo.download(any()))
            .thenAnswer((_) => controller.stream);

        final bloc = _bloc(updateRepo, apkRepo)..add(const UpdateEventInited());

        await bloc.stream.firstWhere(
          (state) => state.status == UpdateViewStatus.available,
        );
        bloc.add(const UpdateEventDownloadTapped());

        await bloc.stream.firstWhere(
          (state) => state.status == UpdateViewStatus.downloading,
        );
        bloc.add(const UpdateEventDownloadCanceled());

        await bloc.stream.firstWhere(
          (state) => state.status == UpdateViewStatus.available,
        );
        await bloc.close();

        verify(() => apkRepo.cancelDownload()).called(1);
      },
    );
  });
}
