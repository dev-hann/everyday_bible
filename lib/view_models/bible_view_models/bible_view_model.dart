// import 'package:everydaybible/controllers/bible_controller.dart';
// import 'package:everydaybible/models/bible.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

// class BibleViewModel extends ChangeNotifier {
//   BibleViewModel({
//     required this.controller,
//   });

//   late BuildContext _context;

//   final BibleController controller;


//   String get appBarTitle => controller.selectedBible.title;

//   List<Chapter> get chapterList=> controller.selectedBible.chapterList;

//   int get selectedChapterIndex => controller.selectedChapterIndex;

//   void init()async{
//     controller.addListener(_listener);
//   }

//   void drawerInit(BuildContext context)=>_context=context;

//   void _listener(){
//     notifyListeners();
//   }
//   void toggleDrawer() {
//     ZoomDrawer.of(_context)?.toggle();
//   }

//   void closeDrawer() {
//     ZoomDrawer.of(_context)?.close();
//   }
// }
