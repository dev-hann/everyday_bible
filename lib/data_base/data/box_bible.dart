import 'package:everydaybible/data_base/data/box.dart';

class BibleBox extends LocalBox {
  @override
  String get name => "BibleBox";

  bool get isEmpty => box.isEmpty;

  dynamic loadBible() {
    return box.get(name);
  }

  Future updateBible(Map<String, dynamic> data) {
    return box.put(name, data);
  }
}
