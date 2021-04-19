import 'package:everydaybible/models/bible.dart';
import 'package:flutter/material.dart';

import 'data_loader/hive_data_loader.dart';
import 'data_loader/web_data_loader.dart';

class BibleDatabase {
  HiveDataLoader _hiveDataLoader = HiveDataLoader();
  WebDataLoader _webDataLoader = WebDataLoader();

   ValueNotifier<Bible?> bibleNotifier = ValueNotifier(null);

   Future initialize()async{
    await _hiveDataLoader.initialize();
    await loadData(DateTime.now());
   }

  set _selectedDateBible(Bible? bible)=>bibleNotifier.value=bible;
  Bible? get selectedDateBible => bibleNotifier.value;

  Future loadData(DateTime dateTime)async{
    Bible? _tmpData =await _hiveDataLoader.bibleFromDate(dateTime);
    if(_tmpData==null){
      _tmpData = await _webDataLoader.bibleFromDate(dateTime);
      updateBible(_tmpData!);
    }
    _selectedDateBible=_tmpData;
  }

  Future updateBible(Bible bible)async{
    _hiveDataLoader.updateBible(bible);
  }

}
