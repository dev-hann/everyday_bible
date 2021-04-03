import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/view_models/view_model_lib.dart';

class DataLoaderViewModel extends BibleViewModel {

  Bible bibleFromDate(DateTime dateTime) {
    ///1. check database
    ///if null, load from firebase
    ///
    ///
    return Bible() ;
  }

  Bible get todayBible => bibleFromDate(DateTime.now());

}

class FirebaseDataLoader extends DataLoader{}

class DatabaseDataLoader extends DataLoader{}


abstract class DataLoader{
  void init();

  void dispose();

  Bible bibleFromDate(DateTime dateTime);

}