import 'package:everydaybible/controllers/qt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:everydaybible/views/dash_board_views/dash_board_view.dart';
class IntroButtonView extends StatelessWidget {
  Widget _loadingWidget() {
    return SizedBox(width: 20, height: 20, child: CircularProgressIndicator());
  }

  Widget _amenButton() {
    return GestureDetector(
        onTap: () {
          Get.to(() => DashBoardView(),
              transition: Transition.fadeIn, duration: Duration(seconds: 1));
        },
        child: Text("Amen"));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(QTController());
    return GetBuilder<QTController>(
      builder: (_controller) {
        _controller.init();
        Widget _switcherChild =
            _controller.selectedQT == null ? _loadingWidget() : _amenButton();
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 1000),
          child: _switcherChild,
        );
      },
    );
  }
}
