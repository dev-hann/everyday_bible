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

  @override
  Future updateSetting(Map<String, dynamic> data) {
    return settingBox.updateSetting(data);
  }
}
