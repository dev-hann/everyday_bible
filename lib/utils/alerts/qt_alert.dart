import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QTAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Get.back,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
            child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "\"EveryDay Bible\"",
                        style:
                        Get.textTheme.headline4!.copyWith(color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          color: Get.theme.primaryColor,
                        ),
                      ),
                      Text("아직 말씀이 준비 되지 않았습니다."),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("확인"),
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }
}
