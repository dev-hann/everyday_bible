import 'package:everydaybible/controllers/qt_controller.dart';
import 'package:everydaybible/views/qt_views/qt_audio_views/qt_audio_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'qt_list_view.dart';
import 'qt_title_view.dart';

class QTView extends StatelessWidget {
  Widget _titleWidget() {
    return const QTTitleView();
  }

  Widget _gospelListView() {
    return const QTListView();
  }

  Widget _audioWidget() {
    return QTAudioView();
  }

  Widget _body() {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: _audioWidget(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight * 0.8),
              child: _titleWidget(),
            ),
            Expanded(child: _gospelListView())
          ],
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Obx(
      () {
        final QTController _controller = Get.find();
        if (_controller.loading.value) {
          return ColoredBox(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Get.theme.primaryColorLight.withOpacity(0.6),
              Get.theme.primaryColorDark.withOpacity(0.5),
              Get.theme.primaryColorDark,
            ],
            stops: [0.1, 0.35, 0.9],
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            _body(),
            _loadingWidget(),
          ],
        ),
      ),
    );
  }
}
