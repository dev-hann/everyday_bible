import 'package:everydaybible/model/setting.dart';
import 'package:everydaybible/repo/setting_repo/repo_setting.dart';
import 'package:everydaybible/use_case/use_case.dart';

/// Use case reading and writing app settings through [SettingRepo].
class SettingUseCase extends UseCase<SettingRepo> {
  /// Creates a settings use case backed by [repo].
  SettingUseCase(super.repo);

  /// Loads the settings, falling back to defaults when reading or parsing
  /// fails.
  Setting loadSetting() {
    try {
      final res = repo.loadSetting();
      return Setting.fromMap(res);
    } on Object {
      return const Setting();
    }
  }

  /// Persists every field of [setting] to the settings table.
  Future<void> updateSetting(Setting setting) {
    return repo.updateSetting(setting.toMap());
  }
}
