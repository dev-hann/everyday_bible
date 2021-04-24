import 'package:everydaybible/models/quite_time.dart';
import 'package:everydaybible/utils/hive_database.dart';
import 'package:hive/hive.dart';

class QTHiveDatabase extends HiveDatabase<QuiteTime>{

  late Box box;

  @override
  Future<void> openBox(String boxName) async{
    box = await Hive.openBox(boxName);
  }

  @override
  Future addData(QuiteTime data) async{
    print("Hive : newData ${data.dateTime}");
    await box.put(data.dateTime, data.toMap());
  }

  @override
  QuiteTime? readData(key) {
   String _tmpKey = QuiteTime.dateTimeFormat(key);
   final _res = box.get(_tmpKey);
   if(_res==null) {
     print("Hive : there's no $_tmpKey Data!");
     return null;
   }
     return QuiteTime.fromHive(Map<String,dynamic>.from(_res));
   }


  @override
  Future updateData(QuiteTime data) {
    // TODO: implement updateData
    throw UnimplementedError();
  }

}