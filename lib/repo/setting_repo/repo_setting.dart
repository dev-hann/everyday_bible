library setting_repo;

import 'package:everydaybible/data_base/data/box_setting.dart';
import 'package:everydaybible/repo/repo.dart';

part 'impl_setting.dart';

abstract class SettingRepo extends Repo {
  dynamic loadSetting();
}
