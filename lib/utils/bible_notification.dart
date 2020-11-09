import 'package:everydaybible/utils/natives/natives.dart';
import 'package:flutter/services.dart';

class BibleNotification extends Natives {
  final String _method = "notification";

  void showMediaStyleNotification() async {
    var res = await methodChannel.invokeMethod(_method + "/mediaStyle");
    print(res);
  }
}
