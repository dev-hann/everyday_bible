import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everydaybible/models/bible.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data_loader.dart';

class FirebaseDataLoader extends DataLoader with FirebaseMixin {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Future<Bible> bibleFromDate(DateTime dateTime) async{
    String _folderName = DateFormat("yyyy-MM-dd").format(dateTime);
    DocumentSnapshot documentSnapshot =
        await _fireStore.collection("Bible").doc(_folderName).get();
    Bible _bible =Bible.fromJson(documentSnapshot.data());
    return _bible;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<Bible> init() async {
    print("init FirebaseDataLoader..");
    String _folderName = DateFormat("yyyy-MM-dd").format(DateTime.now());
    DocumentSnapshot documentSnapshot =
        await _fireStore.collection("Bible").doc(_folderName).get();
    Bible _todayBible =Bible.fromJson(documentSnapshot.data());
    return _todayBible;
  }
}

mixin FirebaseMixin on DataLoader {}
