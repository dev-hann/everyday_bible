import 'package:everydaybible/controller/controller.dart';
import 'package:everydaybible/utils/animations/page_animation.dart';
import 'package:everydaybible/utils/animations/spreading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'every_day_bible.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() {
    return _SplashState();
  }
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {

  Widget _body() {

    AnimationController  _fadeOutAnimation = AnimationController(
        vsync: this, duration: Duration(milliseconds: 700));

    Widget _title() {
      Widget _textAnimation({Widget text, AnimationController controller}) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: controller, curve: Curves.easeIn),
          //Tween<double>(begin: 0.0,end: 1.0).animate(_titleAnimation),
          child: text,
        );
      }

      Widget _titleText() {
        AnimationController _titleAnimation = AnimationController(
          duration: Duration(milliseconds: 1500),
          vsync: this,
        );
        return _textAnimation(
            text: Text(
              "Every Day",
              style: Theme.of(context).textTheme.headline2,
            ),
            controller: _titleAnimation..forward());
      }

      Widget _subTitleText() {
        AnimationController _subTitleAnimation = AnimationController(
          duration: Duration(milliseconds: 1500),
          vsync: this,
        );
        Future.delayed(Duration(milliseconds: 500))
            .then((value) => _subTitleAnimation.forward());
        return _textAnimation(
            text: Text(
              "Text",
              style: Theme.of(context).textTheme.headline2.copyWith(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.bold),
            ),
            controller: _subTitleAnimation);
      }

      return Align(
        alignment: Alignment(-0.7, -0.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleText(),
            _subTitleText(),
          ],
        ),
      );
    }

    Widget _button() {
      AnimationController _btnAnimation = AnimationController(
          vsync: this, duration: Duration(milliseconds: 1000));

      Provider.of<BibleController>(context)
          .init()
          .whenComplete(() => _btnAnimation.forward());

      return Align(
        alignment: Alignment(0.8, 0.8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0).animate(_btnAnimation),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            ),
            FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(_btnAnimation),
              child: GestureDetector(
                  onTap: () async {
                    await _fadeOutAnimation.forward();
                    Navigator.push(context,
                        FadePageRoute(builder: (context) => EveryDayBible()));
                  },
                  child: Text("InTro...")),
            )
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          Theme.of(context).primaryColorLight.withOpacity(0.7),
          Theme.of(context).primaryColorDark,
        ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_fadeOutAnimation),
        child: Stack(
          children: [
            _title(),
            _button(),
          ],
        ),
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
