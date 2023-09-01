library setting_repo;

import 'package:everydaybible/repo/repo.dart';

part 'impl_setting.dart';

abstract class SettingRepo extends Repo {
  dynamic loadSetting();
  Future updateSetting(Map<String, dynamic> data);
}
