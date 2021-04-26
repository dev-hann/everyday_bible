import 'package:everydaybible/controllers/qt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QTAudioTitle extends StatelessWidget {
  const QTAudioTitle();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QTController>(builder: (_controller) {
      return Text(
        _controller.selectedQT!.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    });
  }
}
