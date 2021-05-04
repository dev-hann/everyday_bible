import 'package:everydaybible/models/hive_model.dart';

abstract class HiveDatabase<T extends HiveModel>{


  Future<void> openBox(String boxName);

  Future updateData(T data);

  dynamic readData(dynamic key);

  Future addData(T data);

}