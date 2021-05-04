import 'package:everydaybible/controllers/bible_controller.dart';
import 'package:everydaybible/view_models/bible_view_models/bible_view_model.dart';
import 'package:everydaybible/views/bible_views/bible_chapter_list_view.dart';
import 'package:everydaybible/views/bible_views/bible_drawer_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

/// [todo] deciding View of ui && ux

class BibleView extends StatefulWidget {
  @override
  _BibleViewState createState() => _BibleViewState();
}

class _BibleViewState extends State<BibleView> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.Style1,
      menuScreen: BibleDrawerMenuView(),
      mainScreen: _BibleView(),
      showShadow: true,
      backgroundColor: Get.theme.primaryColor.withOpacity(0.5),
      slideWidth: Get.width * .65,
      angle: 0,
      openCurve: Curves.bounceInOut,
      closeCurve: Curves.bounceInOut,
      duration: Duration(milliseconds: 150),
    );
  }
}

class _BibleView extends StatefulWidget {
  @override
  __BibleViewState createState() => __BibleViewState();
}

class __BibleViewState extends State<_BibleView>  {
  late BibleViewModel _viewModel;

  void initState() {
    super.initState();
    final BibleController _controller = Get.find();
    _viewModel = BibleViewModel(controller: _controller);
    _viewModel.addListener(_listener);
    _viewModel.init();
  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(_viewModel.appBarTitle),
      leading: IconButton(
        icon: FaIcon(FontAwesomeIcons.bars),
        onPressed: _viewModel.toggleDrawer,
      ),
      actions: [
        IconButton(icon: FaIcon(FontAwesomeIcons.cog), onPressed: () {})
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _viewModel.drawerInit(context);
    return GestureDetector(
      onTap: _viewModel.closeDrawer,
      child: Scaffold(
        backgroundColor: Get.theme.primaryColor,
        appBar: _appBar(),
        body: BibleChapterListView(
          chapterList: _viewModel.chapterList,
          initIndex: _viewModel.selectedChapterIndex,
        ),
      ),
    );
  }

}
