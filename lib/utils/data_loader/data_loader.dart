import 'package:everydaybible/models/everyday_bible.dart';
import 'package:intl/intl.dart';
abstract class DataLoader{

  Future<EverydayBible?> get todayBible async=> await bibleFromDate(DateTime.now());

  Future<void> initialize();

  void dispose();

  Future<EverydayBible?> bibleFromDate(DateTime dateTime);

  String bibleFormat(DateTime dateTime)=>DateFormat("yyyy-MM-dd").format(dateTime);

}


