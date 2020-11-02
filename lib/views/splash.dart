
import 'file:///D:/flutter_project/EveryDayBible/lib/views/every_day_bible.dart';
import 'package:everydaybible/utils/bible_parser.dart';
import 'package:everydaybible/views/wave_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() {
    return _SplashState();
  }
}

class _SplashState extends State<Splash>  {

  BibleParser _parser = BibleParser();
  void initState(){

    super.initState();
  }
  void dispose(){
    super.dispose();
  }


  Widget _body() {
    Widget _title() {
      return Align(
        alignment: Alignment(-0.8, -0.6),
        child: Text.rich(
            TextSpan(
                style: Theme.of(context).textTheme.headline2,
                children: [
                  TextSpan(text: "Every Day\n"),
                  TextSpan(text: "Title",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)),
                ])),
      );
    }

/*    Widget _splashAnimation() {
      return WaveAnimation(
        amplitude: 40,
      );
    }*/

    Widget _button() {
      return Align(
        alignment: Alignment(0.0, 0.7),
        child: FlatButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=>EveryDayBible()
            ));
          },
          child: Text("button"),
        ),
      );
    }

    return Stack(
      children: [
        _title(),
       // _splashAnimation(),
        _button(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    _parser.init();
    return Scaffold(
      body: _body(),
    );
  }
}
