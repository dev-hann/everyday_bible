import 'package:everydaybible/models/quite_time.dart';
import 'package:everydaybible/utils/hive_database.dart';
import 'package:hive/hive.dart';

class QTHiveDatabase extends HiveDatabase<QuiteTimeOld>{

  late Box box;

  @override
  Future<void> openBox(String boxName) async{
    box = await Hive.openBox(boxName);
  }

  @override
  Future addData(QuiteTimeOld data) async{
    print("QTHive : newData ${data.dateTime}");
    await box.put(data.dateTime, data.toMap());
  }

  @override
  QuiteTimeOld? readData(key) {
   String _tmpKey = QuiteTimeOld.dateTimeFormat(key);
   final _res = box.get(_tmpKey);
   if(_res==null) {
     print("QTHive : there's no $_tmpKey Data!");
     return null;
   }
     return QuiteTimeOld.fromHive(Map<String,dynamic>.from(_res));
   }


  @override
  Future updateData(QuiteTimeOld data) {
    // TODO: implement updateData
    throw UnimplementedError();
  }

}
