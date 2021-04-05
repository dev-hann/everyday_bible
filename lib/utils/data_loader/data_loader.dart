import 'package:everydaybible/models/bible.dart';

abstract class DataLoader{

  Future<Bible> get todayBible async=> await bibleFromDate(DateTime.now());

  Future<Bible> init();

  void dispose();

  Future<Bible> bibleFromDate(DateTime dateTime);

}


