
import 'package:everydaybible/utils/bible_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'every_day_bible.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() {
    return _SplashState();
  }
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  BibleParser _parser = BibleParser();
  AnimationController _titleAniController;

  void initState() {
    super.initState();
   _parser.init();
    _titleAniController =
    AnimationController(duration: Duration(milliseconds: 1500), vsync: this)
      ..forward()
      ..addListener((){setState(() {});});
  }


  Widget _body() {
    Widget _title() {
      TextStyle _theme = Theme
          .of(context)
          .textTheme
          .headline2;
      Widget _aniContainer(Widget text) {
        return AnimatedContainer(
          padding: EdgeInsets.only(left: _titleAniController.value * 20),
          duration: Duration.zero,
          child: Opacity(opacity: _titleAniController.value, child: text),
        );
      }

      return Align(
        alignment: Alignment(-0.7, -0.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _aniContainer(Text(
              "Every Day",
              style: _theme,
 //             style: _theme.copyWith(fontFamily: "Norican",fontWeight: FontWeight.bold),
//              style: _theme.copyWith(fontFamily: "Fondamento"),
            )),
            _aniContainer(Text(
              "Title",
              style: _theme.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme
                      .of(context)
                      .primaryColorDark),
            ))
          ],
        ),
      );
    }



    BoxDecoration _backgroundColor() {
      return BoxDecoration(
        gradient: LinearGradient(colors: [
          Theme
              .of(context)
              .primaryColorLight
              .withOpacity(0.7),
          Theme
              .of(context)
              .primaryColorDark,
        ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
      );
    }

    return Container(
      decoration: _backgroundColor(),
      child: Stack(
        children: [
          _title(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: _body(),
    );
  }
}
