import 'package:everydaybible/models/bible.dart';

import 'data_loader/hive_data_loader.dart';
import 'data_loader/web_data_loader.dart';

///each database init has return [todayBibleData]
class BibleDatabase {
 // FirebaseDataLoader _firebaseDataLoader = FirebaseDataLoader();
  HiveDataLoader _hiveDataLoader = HiveDataLoader();
  WebDataLoader _webDataLoader = WebDataLoader();

  Bible? _selectedDateBible;

  Bible get selectedDateBible => _selectedDateBible!;

  Future init() async {
   _selectedDateBible =  await _hiveDataLoader.init();
   if(_selectedDateBible==null) {
     _selectedDateBible = await _webDataLoader.init();
     _hiveDataLoader.pushBible(_selectedDateBible!);
   }
  }

}
