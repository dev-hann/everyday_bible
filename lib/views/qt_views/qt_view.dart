import 'package:everydaybible/controllers/qt_controller.dart';
import 'package:everydaybible/views/qt_views/qt_audio_views/qt_audio_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:everydaybible/widgets/bible_scaffold.dart';

import 'package:get/get.dart';
import 'qt_list_view.dart';
import 'qt_title_view.dart';


/// [todo] calender && hide title(title space too big)
class QTView extends StatelessWidget {
  AppBar _appBar(){
      return AppBar(
        leading: IconButton(icon: FaIcon(FontAwesomeIcons.pagelines), onPressed: Get.back),
        actions: [
          IconButton(icon: FaIcon(FontAwesomeIcons.calendar), onPressed: (){}),
          IconButton(icon: FaIcon(FontAwesomeIcons.cog), onPressed: (){})
        ],
      );
  }

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
            _titleWidget(),
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
    return BibleScaffold(
      appBar: _appBar(),
      body: Stack(
        children: [
          _body(),
          _loadingWidget(),
        ],
      ),
    );
  }
}
