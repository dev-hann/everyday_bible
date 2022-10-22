part of setting_repo;

class SettingImpl extends SettingRepo {
  final SettingBox settingBox = SettingBox();
  @override
  Future init() {
    return settingBox.openBox();
  }

  @override
  dynamic loadSetting() {
    return settingBox.loadSetting();
  }
}
