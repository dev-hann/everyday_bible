import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/utils/data_loader/firebase_data_loader.dart';
import 'package:everydaybible/utils/data_loader/hive_data_loader.dart';

///each database init has return [todayBibleData]
class BibleDatabase {
  FirebaseDataLoader _firebaseDataLoader = FirebaseDataLoader();
  HiveDataLoader _hiveDataLoader = HiveDataLoader();

  Bible _selectedDateBible;

  Bible get selectedDateBible =>_selectedDateBible;

  Future init() async{
    //_loadHive();
    _selectedDateBible = await _firebaseDataLoader.init();
  }

  void _loadHive() {
    _hiveDataLoader.init();
  }

  Future _loadFirebase() async {
   _selectedDateBible = await _firebaseDataLoader.init();
  }
}
