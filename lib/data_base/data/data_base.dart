import 'dart:io';

const configDir = ".config/everyday_bible";

abstract class DataBase {
  String get dbName;

  bool get isEmpty;

  String get configDir {
    return "/home/${Platform.environment["USER"]}/$dbName";
  }

  Future init() async {
    final dir = Directory(configDir);
    final isExist = await dir.exists();
    if (!isExist) {
      await dir.create();
    }
  }
}
