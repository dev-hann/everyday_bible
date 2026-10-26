import 'package:everydaybible/model/failure.dart';
import 'package:everydaybible/model/update/app_release.dart';
import 'package:everydaybible/repo/apk_install_repo/apk_install_repo.dart';
import 'package:everydaybible/repo/update_repo/update_repo.dart';
import 'package:everydaybible/use_case/update_use_case/update_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockUpdateRepo extends Mock implements UpdateRepo {}

class _MockApkInstallRepo extends Mock implements ApkInstallRepo {}

AppRelease _release(String version) => AppRelease(
      version: version,
      htmlUrl: 'https://github.com/dev-hann/everyday_bible/releases',
      downloadUrl: 'https://github.com/dev-hann/everyday_bible/a.apk',
    );

void main() {
  late _MockUpdateRepo updateRepo;
  late _MockApkInstallRepo apkRepo;
  late UpdateUseCase useCase;

  setUp(() {
    updateRepo = _MockUpdateRepo();
    apkRepo = _MockApkInstallRepo();
    useCase = UpdateUseCase(updateRepo, apkRepo);
  });

  group('UpdateUseCase.checkForUpdate', () {
    test('marks a higher remote version as available', () async {
      when(() => updateRepo.getLatestRelease())
          .thenAnswer((_) async => Right(_release('3.1.0')));

      final result = await useCase.checkForUpdate('3.0.0');

      expect(
        result.fold(
          (failure) => failure,
          (check) => check.isUpdateAvailable,
        ),
        isTrue,
      );
    });

    test('marks the same version as up to date', () async {
      when(() => updateRepo.getLatestRelease())
          .thenAnswer((_) async => Right(_release('3.0.0')));

      final result = await useCase.checkForUpdate('3.0.0');

      expect(
        result.fold((failure) => failure, (check) => check.isUpdateAvailable),
        isFalse,
      );
    });

    test('ignores the build number suffix', () async {
      when(() => updateRepo.getLatestRelease())
          .thenAnswer((_) async => Right(_release('3.0.0+1')));

      final result = await useCase.checkForUpdate('3.0.0');

      expect(
        result.fold((failure) => failure, (check) => check.isUpdateAvailable),
        isFalse,
      );
    });

    test('compares version parts numerically', () async {
      when(() => updateRepo.getLatestRelease())
          .thenAnswer((_) async => Right(_release('3.0.10')));

      final result = await useCase.checkForUpdate('3.0.9');

      expect(
        result.fold((failure) => failure, (check) => check.isUpdateAvailable),
        isTrue,
      );
    });

    test('pads missing parts with zero', () async {
      when(() => updateRepo.getLatestRelease())
          .thenAnswer((_) async => Right(_release('4')));

      final result = await useCase.checkForUpdate('3.9.9');

      expect(
        result.fold((failure) => failure, (check) => check.isUpdateAvailable),
        isTrue,
      );
    });

    test('returns Left when the remote version is not numeric', () async {
      when(() => updateRepo.getLatestRelease())
          .thenAnswer((_) async => Right(_release('stable')));

      final result = await useCase.checkForUpdate('3.0.0');

      expect(result.isLeft(), isTrue);
    });

    test('propagates the repository failure', () async {
      when(() => updateRepo.getLatestRelease())
          .thenAnswer((_) async => const Left(Failure('offline')));

      final result = await useCase.checkForUpdate('3.0.0');

      expect(
        result.fold((failure) => failure.message, (_) => ''),
        'offline',
      );
    });
  });
}
