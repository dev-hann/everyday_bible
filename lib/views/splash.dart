import 'package:everydaybible/controller/controller.dart';
import 'package:everydaybible/utils/animations/page_animation.dart';
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
  AnimationController _titleAnimation;
  AnimationController _fadeOutAnimation;

  bool _isLoading = true;

  void initState() {
    super.initState();
   /* Provider.of<BibleController>(context, listen: false)
        .loadData()
        .whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });*/
    _fadeOutAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _titleAnimation = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  Widget _body() {
    Widget _title() {
      TextStyle _theme = Theme.of(context).textTheme.headline2;
      Widget _aniContainer(Widget text) {
        return AnimatedBuilder(
          animation: _titleAnimation,
          builder: (_, child) {
            return Container(
              padding: EdgeInsets.only(
                left: _titleAnimation.value * 20,
              ),
              child: Opacity(
                opacity: _titleAnimation.value,
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
            _aniContainer(
              Text(
                "Every Day",
                style: _theme,
/*                //             style: _theme.copyWith(fontFamily: "Norican",fontWeight: FontWeight.bold),
//              style: _theme.copyWith(fontFamily: "Fondamento"),*/
              ),
            ),
            _aniContainer(
              Text(
                "Bible",
                style: _theme.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark),
              ),
            ),
          ],
        ),
      );
    }

    Widget _button() {
      AnimationController _btnAnimation= AnimationController(vsync: this,duration: Duration(milliseconds: 1500));
      Animation _fadeOut = Tween<double>(begin: 1.0,end:0.0).animate(_btnAnimation);
     Animation _fadeIn = Tween<double>(begin: 0.0,end:1.0).animate(_btnAnimation) ;
      Provider.of<BibleController>(context, listen: false)
          .loadData()
          .whenComplete(() {
          _btnAnimation.forward();
      });

      return Align(
        alignment: Alignment(0.8, 0.8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            FadeTransition(
              opacity:_fadeOut ,
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            ) ,
            FadeTransition(
              opacity: _fadeIn,
              child: GestureDetector(
                onTap: () {
                  _fadeOutAnimation.forward().whenComplete(() {
                    Navigator.push(context, FadePageRoute(builder: (context)=>EveryDayBible()));
                  });
                },
                child: Text(
                  "hello",
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight, fontSize: 22),
                ),
              ),
            ),
          ],
        )
        /* (_isLoading)
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              )
            : FlatButton(
                onPressed: () {
                 _fadeOutAnimation.forward().whenComplete(() {
                   Navigator.push(context, FadePageRoute(builder: (context)=>EveryDayBible()));
                 });
                },
                child: Text(
                  "hello",
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight, fontSize: 22),
                ),
              ),*/
      );
    }

    BoxDecoration _backgroundColor() {
      return BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          Theme.of(context).primaryColorLight.withOpacity(0.7),
          Theme.of(context).primaryColorDark,
        ],
            begin: Alignment.topLeft, end: Alignment.bottomCenter),
      );
    }

    Widget _fadeOut() {
      return FadeTransition(
        opacity: _fadeOutAnimation,
        child: SizedBox.expand(
          child: ColoredBox(
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      );

      /* return AnimatedBuilder(
          animation: _fadeOutAnimationController,
          builder: (_,child){
            return CustomPaint(
              size: Size.infinite,
              painter: SpreadingAnimation(
                beginPos: Alignment(0.8, 0.8),
                  color: Theme.of(context).primaryColorLight,
                  animation: _fadeOutAnimationController.value
              ),
            );
          });*/
    }

    return Container(
      decoration: _backgroundColor(),
      child: Stack(
        children: [
          _title(),
          _fadeOut(),
          _button(),
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
