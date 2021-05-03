import 'package:everydaybible/views/intro_views/intro_button_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'intro_title_view.dart';
import 'package:everydaybible/widgets/bible_scaffold.dart';

class IntroView extends StatelessWidget {
  Widget _titleWidget() {
    return IntroTitleView();
  }

  Widget _buttonWidget() {
    return IntroButtonView();
  }

  Widget _copyRightWidget() {
    return Text(
      "Copyright © 2018 Scripture Union Korea. All rights reserved.",
      style: Get.textTheme.bodyText1!
          .copyWith(color: Colors.brown.shade300, fontSize: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BibleScaffold(
      body: Stack(
        children: [
          Align(alignment: Alignment(-0.7, -0.5), child: _titleWidget()),
          Align(alignment: Alignment(0.8, 0.7), child: _buttonWidget()),
          Align(alignment: Alignment(0, 0.9), child: _copyRightWidget()),
        ],
      ),
    );
  }
}