import 'package:everydaybible/models/bible.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EveryDayBible extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EveryDayBibleState();
  }
}

class _EveryDayBibleState extends State<EveryDayBible> with SingleTickerProviderStateMixin{
  Bible _bible = Bible();
  ScrollController _scrollController;
  AnimationController _playAnimation;

  double _currentScrollPos=0.0;
  void initState(){
    super.initState();
    _playAnimation = AnimationController(vsync: this,duration: Duration(milliseconds: 300));
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener(){
    double _max =_scrollController.position.maxScrollExtent;
    double _current =_scrollController.offset ;
    _currentScrollPos = _current/_max;

    setState(() {});
  }
Widget _appBar(){
    return AppBar(
      title: Text(_bible.title),
      automaticallyImplyLeading: false,
      actions: [
           IconButton(
             onPressed: (){
               if(_playAnimation.isCompleted){
                _playAnimation.reverse() ;
               }else {
                 _playAnimation.forward();
               }
             },
             icon: AnimatedIcon(
               progress: _playAnimation,
               icon: AnimatedIcons.play_pause,
             ),
           ),
      ],
    );
}
Widget _body() {
  Widget _contents() {
    return ListView(
      controller: _scrollController,
      children: _bible.contents.entries
          .map((e) =>
          ListTile(
            leading: Text("${e.key}"),
            title: Text("${e.value}"),
          ))
          .toList(),
    );
  }

  Widget _sideBar(){
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        height: ScreenUtil().screenHeight*_currentScrollPos,
        width: 2,
        child: ColoredBox(
          color: Theme.of(context).primaryColorDark,
        ),
      ),
    );
  }
  return Stack(
    children: [
      _contents(),
      _sideBar()
    ],
  );

}
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }
}
