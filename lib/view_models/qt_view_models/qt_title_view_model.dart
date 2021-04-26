import 'package:everydaybible/controllers/qt_controller.dart';
import 'package:everydaybible/utils/alerts/qt_alert.dart';
import 'package:get/get.dart';

class QTTitleViewModel{
  QTTitleViewModel(this.controller);

  final QTController controller;

  String get title=> controller.selectedQT!.title;

  String get subtitle=> controller.selectedQT!.subTitle;

  String get dateTime=> controller.selectedQT!.dateTime;


  DateTime get _dateTime{
    List<int> dateList = dateTime.split("-").map((e) => int.parse(e)).toList();
    return DateTime(dateList[0], dateList[1], dateList[2]);
  }

  bool get hasTomorrow => !(_dateTime.difference(DateTime.now()).inDays > 5);

  void onTapPreButton(){
    controller.loadData(_dateTime.add(Duration(days: -1)));
  }
  void onTapNextButton(){
    if(!hasTomorrow){
     Get.dialog(QTAlert());
    }else {
      controller.loadData(_dateTime.add(Duration(days: 1)));
    }
  }
}
