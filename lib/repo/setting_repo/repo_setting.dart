import 'package:drift/drift.dart' show DoUpdate;
import 'package:everydaybible/data_base/app_database.dart';
import 'package:everydaybible/repo/repo.dart';

part 'impl_setting.dart';

abstract class SettingRepo extends Repo {
  Map<String, dynamic> loadSetting();
  Future updateSetting(Map<String, dynamic> data);
}
