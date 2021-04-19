import 'package:everydaybible/models/bible.dart';
import 'package:intl/intl.dart';
abstract class DataLoader{

  Future<Bible?> get todayBible async=> await bibleFromDate(DateTime.now());

  Future<void> initialize();

  void dispose();

  Future<Bible?> bibleFromDate(DateTime dateTime);

  String bibleFormat(DateTime dateTime)=>DateFormat("yyyy-MM-dd").format(dateTime);

}


