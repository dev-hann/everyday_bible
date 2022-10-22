import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';

final user = Platform.environment["USER"];
final configDir = "/home/$user/.config/everyday_bible";

abstract class LocalBox {
  static Future init() async {
    final dir = Directory(configDir);
    if (!await dir.exists()) {
      await dir.create();
    }
    return Hive.initFlutter(configDir);
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
