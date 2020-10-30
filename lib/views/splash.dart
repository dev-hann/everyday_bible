
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
                  TextSpan(text: "Title",style: TextStyle(color: Theme.of(context).primaryColor)),
                ])),
      );
    }

    Widget _splashAnimation() {
      return WaveAnimation(
        amplitude: 40,
      );
    }

    Widget _button() {
      return Align(
        alignment: Alignment(0.0, 0.7),
        child: RaisedButton(
          onPressed: () {},
          child: Text("button"),
        ),
      );
    }

    return Stack(
      children: [
        _title(),
        _splashAnimation(),
        _button(),
      ],
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
