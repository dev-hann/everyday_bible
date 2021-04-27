import 'package:everydaybible/widgets/bible_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';


/// [todo] deciding View of ui && ux
class BibleView extends StatelessWidget {

  AppBar _appBar(){
    return AppBar(
      leading: IconButton(icon: FaIcon(FontAwesomeIcons.pagelines), onPressed: Get.back),
      actions: [
        IconButton(icon: FaIcon(FontAwesomeIcons.cog), onPressed: (){})
      ],
    );
  }

  Widget _title() {
    return SliverToBoxAdapter(
      child: Center(child: Text("title")),
    );
  }

  Widget _gospelListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          return Text("$index");
        },
        childCount: 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BibleScaffold(
      appBar: _appBar(),
      body: CustomScrollView(
        slivers: [
          _title(),
          // _gospelListView(),
        ],
      ),
    );
  }
}
