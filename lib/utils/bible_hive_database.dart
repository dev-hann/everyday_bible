import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/utils/hive_database.dart';
import 'package:hive/hive.dart';

class BibleHiveDatabase extends HiveDatabase<BibleOld>{
  late Box box;


  Future addDataList (List<BibleOld> list)async{
    for(final bible in list){
      await addData(bible);
    }
  }
  @override
  Future addData(BibleOld data) async{
    print("BibleHive : newData ${data.title}");
    await box.add(data.toMap());
  }

  @override
  Future<void> openBox(String boxName) async{
    box = await Hive.openBox(boxName);
  }

  @override
  List<BibleOld>? readData(_) {
    final _res = box.values.toList();
    if(_res.length==0) {
      print("BibleHive : there's no Bible Data!");
      return null;
    }
     return BibleOld.fromListMap(_res);
  }

  @override
  Future updateData(BibleOld data) {
    // TODO: implement updateData
    throw UnimplementedError();
  }

}
