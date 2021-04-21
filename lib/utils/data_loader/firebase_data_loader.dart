/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everydaybible/models/everyday_bible.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data_loader.dart';

class FirebaseDataLoader extends DataLoader with FirebaseMixin {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Future<Bible?> bibleFromDate(DateTime dateTime) async{
    String _folderName = DateFormat("yyyy-MM-dd").format(dateTime);
    DocumentSnapshot documentSnapshot =
        await _fireStore.collection("Bible").doc(_folderName).get();
    if(documentSnapshot.data()==null){
      print("There's no data in Firebase.");
      return null;
    }
    print("loading Completed $_folderName's Bible from Firebase");
    return Bible.fromHive(documentSnapshot.data()!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<Bible?> init() async {
    print("init FirebaseDataLoader..");
    Bible? _todayBible =await bibleFromDate(DateTime.now());
    return _todayBible;
  }
}

mixin FirebaseMixin on DataLoader {}
*/
