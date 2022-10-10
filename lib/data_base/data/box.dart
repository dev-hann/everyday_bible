import 'package:hive_flutter/hive_flutter.dart';

abstract class LocalBox {
  static Future init() {
    return Hive.initFlutter();
  }

  String get name;
  late Box box;
  Future<bool> openBox() async {
    try {
      box = await Hive.openBox(name);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future clearBox() async {
    await box.clear();
  }
}



