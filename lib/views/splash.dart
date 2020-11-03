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
  AnimationController _animationController;

  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  Widget _body() {
    Widget _title() {
      TextStyle _theme = Theme.of(context).textTheme.headline2;
      Widget _aniContainer(Widget text) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (_, child) {
            return Container(
              padding: EdgeInsets.only(
                left: _animationController.value * 20,
              ),
              child: Opacity(
                opacity: _animationController.value,
                child: text,
              ),
            );
          },
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
              "Bible",
              style: _theme.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark),
            ))
          ],
        ),
      );
    }

    Widget _button() {
      return Align(
        alignment: Alignment(0.8, 0.8),
        child: FutureBuilder(
          future: _parser.init(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EveryDayBible()));
                },
                child: Text("Button"),
              );
            } else {
              return SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
    }

    BoxDecoration _backgroundColor() {
      return BoxDecoration(
        gradient: LinearGradient(
            colors: <Color>[
          Theme.of(context).primaryColorLight.withOpacity(0.7),
          Theme.of(context).primaryColorDark,
        ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
      );
    }

    return Container(
      decoration: _backgroundColor(),
      child: Stack(
        children: [_title(), _button()],
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
