import 'package:hive/hive.dart';

abstract class LocalBox {
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

  Future clearBox()async{
    await box.clear();
  }

}
