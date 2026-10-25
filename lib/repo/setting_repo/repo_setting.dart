import 'package:drift/drift.dart' show DoUpdate;
import 'package:everydaybible/data_base/app_database.dart';
import 'package:everydaybible/repo/repo.dart';

part 'impl_setting.dart';

/// Repository persisting app settings in the drift `settings` table.
abstract class SettingRepo extends Repo {
  /// Returns a copy of all cached settings.
  Map<String, dynamic> loadSetting();

  /// Upserts every entry of [data] into the settings table.
  Future<void> updateSetting(Map<String, dynamic> data);
}
