import 'package:everydaybible/data_base/data/box.dart';

class SettingBox extends LocalBox {
  @override
  String get name => "SettingBox";

  dynamic loadSetting() {
    return box.get(name);
  }

  Future updateSetting(Map<String, dynamic> data) {
    return box.put(name, data);
  }
}
