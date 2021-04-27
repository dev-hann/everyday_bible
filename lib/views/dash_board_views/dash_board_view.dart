import 'dart:ui';

import 'package:everydaybible/views/bible_views/bible_view.dart';
import 'package:everydaybible/views/qt_views/qt_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'bible_tree_view.dart';
import 'package:everydaybible/widgets/bible_scaffold.dart';
import 'package:everydaybible/widgets/glasses_container.dart';

class DashBoardView extends StatelessWidget {
  Widget _bibleTreeView() {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: Get.width * 0.7,
        height: Get.width * 0.7,
        child: BibleTreeView(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        IconButton(icon: FaIcon(FontAwesomeIcons.cog), onPressed: () {})
      ],
    );
  }

  Widget _bibleMenuListView() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GlassContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _menuItem(
                    icon: FaIcon(FontAwesomeIcons.bible),
                    label: "Bible",
                    onTap: () {
                      Get.to(()=>BibleView());
                    }),
                _menuItem(
                    icon: FaIcon(FontAwesomeIcons.bookOpen),
                    label: "QT",
                    onTap: () {
                      Get.to(()=>QTView());
                    }),
                _menuItem(
                    icon: FaIcon(FontAwesomeIcons.chartBar),
                    label: "Chart",
                    onTap: () {}),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
      {required Widget icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 5,),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BibleScaffold(
      appBar: _appBar(),
      body: CustomScrollView(
        slivers: [
          _bibleTreeView(),
          _bibleMenuListView(),
        ],
      ),
    );
  }
}
