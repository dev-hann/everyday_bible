import 'package:everydaybible/models/bible.dart';
import 'package:flutter/material.dart';

import 'data_loader/hive_data_loader.dart';
import 'data_loader/web_data_loader.dart';

///each database init has return [todayBibleData]
class BibleDatabase {
  HiveDataLoader _hiveDataLoader = HiveDataLoader();
  WebDataLoader _webDataLoader = WebDataLoader();

   ValueNotifier<Bible?> bibleNotifier = ValueNotifier(null);

  set _selectedDateBible(Bible? bible)=>bibleNotifier.value=bible;
  Bible? get selectedDateBible => bibleNotifier.value;

  Future init() async {
   _selectedDateBible =  await _hiveDataLoader.init();
   if(selectedDateBible==null) {
     _selectedDateBible = await _webDataLoader.init();
     _hiveDataLoader.pushBible(selectedDateBible!);
   }
  }

  Future loadData(DateTime dateTime)async{
    Bible? _tmpData =await _hiveDataLoader.bibleFromDate(dateTime);
    if(_tmpData==null){
      _tmpData = await _webDataLoader.bibleFromDate(dateTime);
      _hiveDataLoader.pushBible(_tmpData!);
    }
    _selectedDateBible=_tmpData;
  }


}
