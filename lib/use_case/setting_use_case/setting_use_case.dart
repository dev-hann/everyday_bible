import 'package:everydaybible/models/setting.dart';
import 'package:everydaybible/repo/setting_repo/repo_setting.dart';
import 'package:everydaybible/use_case/use_case.dart';

class SettingUseCase extends UseCase<SettingRepo> {
  SettingUseCase(super.repo);

  Setting loadSetting() {
    try {
      final res = repo.loadSetting();
      return Setting.fromMap(res);
    } catch (e) {
      return const Setting();
    }
  }
}
