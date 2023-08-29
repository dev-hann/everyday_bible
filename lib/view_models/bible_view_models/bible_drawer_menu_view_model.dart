// import 'dart:ui';

// import 'package:everydaybible/controllers/bible_controller.dart';
// import 'package:everydaybible/models/bible.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';

// class BibleDrawerMenuViewModel extends ChangeNotifier {
//   BibleDrawerMenuViewModel({
//     required this.controller,
//   });

//   final BibleController controller;

//   List<BibleOld> _bibleList = [];

//   List<BibleOld> get bibleList => _bibleList;

//   int get bibleListLength => _bibleList.length;

//   late List<bool> expandedList=List.filled(66, false);

//   void init() async {
//     _bibleList = controller.bibleList;
//     notifyListeners();
//   }

//   AutoScrollController scrollController = AutoScrollController(
//       viewportBoundaryGetter: () =>
//           Rect.fromLTRB(0, 0, 0, Get.bottomBarHeight));


//   void onTapMenuItem(int index) async {
//     if (expandedList[index]) {
//       expandedList[index] = false;
//       notifyListeners();
//       return;
//     } else {
//       expandedList = List.filled(66, false);
//       expandedList[index] = true;
//     }
//     notifyListeners();
//     await Future.delayed(Duration(milliseconds: 200));
//     scrollController.scrollToIndex(index,
//         preferPosition: AutoScrollPosition.begin);
//   }

//   void onTapChapter(int titleIndex, int chapterIndex){
//     controller.selectedBible = _bibleList[titleIndex];
//     controller.selectedChapterIndex = chapterIndex;
//   }
// }
