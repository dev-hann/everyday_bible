part of 'repo_setting.dart';

class SettingImpl extends SettingRepo {
  final _db = AppDatabase.instance;

  Map<String, String> _cache = {};

  SettingImpl() {
    _db.select(_db.settings).watch().listen((rows) {
      _cache = {for (final row in rows) row.key: row.value};
    });
  }

  @override
  Map<String, dynamic> loadSetting() {
    return Map<String, dynamic>.from(_cache);
  }

  @override
  Future updateSetting(Map<String, dynamic> data) async {
    await _db.batch((batch) {
      for (final entry in data.entries) {
        batch.insert(
          _db.settings,
          SettingsCompanion.insert(
            key: entry.key,
            value: entry.value.toString(),
          ),
          onConflict: DoUpdate(
            (_) => SettingsCompanion.insert(
              key: entry.key,
              value: entry.value.toString(),
            ),
          ),
        );
      }
    });
  }
}
