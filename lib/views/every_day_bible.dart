import 'dart:async';

import 'package:everydaybible/controller/controller.dart';
import 'package:everydaybible/views/bottom_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EveryDayBible extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EveryDayBibleState();
  }
}

class _EveryDayBibleState extends State<EveryDayBible>
    with TickerProviderStateMixin {
  BibleController _bibleController;

  void initState() {
    super.initState();
    _bibleController = Provider.of<BibleController>(context, listen: false);
  }

  void dispose() {
    super.dispose();
  }

  Widget _body() {
    Widget _title() {
      return Align(
          alignment: Alignment(-0.8, -0.8),
          child: Text.rich(
            TextSpan(children: [
//              TextSpan(text: _bibleController.dateTime.toString()+"\n",style: Theme.of(context).textTheme.bodyText1),
              TextSpan(text: _bibleController.title + "\n"),
              TextSpan(
                  text: _bibleController.subTitle,
                  style: Theme.of(context).textTheme.subtitle2)
            ]),
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontWeight: FontWeight.bold),
          ));
    }

    Widget _gospelListView() {
      Widget _gospelBox() {
        Widget _sectionLine(int _chapter) {


          return Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text("$_chapter"),
                  )),
              Expanded(
                  flex: 9,
                  child: Divider(
                    color: Colors.white70,
                  ))
            ],
          );
        }

        Widget _sectionText() {
          return Text("${_bibleController.gospels.values.first}");
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_sectionLine(2), _sectionText()],
          ),
        );
      }

      return Align(
        alignment: Alignment(0,0.3),
        child: SizedBox(
          width: double.infinity,
          height: ScreenUtil().screenHeight/1.8,
          child: PageView(
            scrollDirection: Axis.vertical,
            children: [
              _gospelBox(),
              _gospelBox(),
              _gospelBox(),
              _gospelBox(),
            ],
          ),
        ),
      );
    }

    Widget _bottomPlayer(){
      return Align(
        alignment: Alignment.bottomCenter,
        child: BottomPlayer(),
      );
    }


    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          Theme.of(context).primaryColorLight.withOpacity(0.6),
          Theme.of(context).primaryColorDark.withOpacity(0.6),
          Theme.of(context).primaryColorDark,
        ], stops: [
          0.1,
          0.35,
          0.9
        ], begin: Alignment.topRight, end: Alignment.bottomCenter),
      ),
      child: Center(
        child: Stack(
          children: [
            _title(),
            _gospelListView(),
            _bottomPlayer()

          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _body(),
    );
  }
}
