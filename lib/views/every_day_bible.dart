import 'package:everydaybible/controller/controller.dart';
import 'package:flutter/material.dart';
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
  ScrollController _scrollController;
  AnimationController _playButtonAnimation;
  double _currentScrollPos = 0.0;

  void initState() {
    super.initState();
    _bibleController = Provider.of<BibleController>(context, listen: false);
    _playButtonAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    double _max = _scrollController.position.maxScrollExtent;
    double _current = _scrollController.offset;
    _currentScrollPos = _current / _max;

    setState(() {});
  }

  void dispose() {
    super.dispose();
    _bibleController.audioDispose();
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

    Widget _gospelList() {
      print(_bibleController.gospels);
      return Align(
        alignment: Alignment(1, 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [

/*
            Text(_bibleController.gospels[0]),
            Text(_bibleController.gospels[1]),
*/
            Text(
              """
Flutter: How to Use Gradients and the GradientAppBar Plugin ...www.digitalocean.com › tutorials › flutter-flutter-gradient
Apr 22, 2019 — The key to this is the addition of a decoration and boxDecoration to our Container widget. This allows us to define a LinearGradient which can be given colors , as well as a begin and end Alignment .""",
            ),
            SizedBox(height: 15),
            Text(
              """
Flutter: How to Use Gradients and the GradientAppBar Plugin ...www.digitalocean.com › tutorials › flutter-flutter-gradient
Apr 22, 2019 — The key to this is the addition of a decoration and boxDecoration to our Container widget. This allows us to define a LinearGradient which can be given colors , as well as a begin and end Alignment .""",
            )
          ],
        ),
      );
    }

    Widget _bottom() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
//        color: Colors.grey,
          height: kToolbarHeight,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_playButtonAnimation.isCompleted) {
                    _playButtonAnimation.reverse();
                    _bibleController.audioPause();
                  } else {
                    _playButtonAnimation.forward();
                    _bibleController.audioPlay();
                  }
                },
                icon: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorDark,
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _playButtonAnimation,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(_bibleController.totalDuration.toString())
            ],
          ),
        ),
      );
    }
    BoxDecoration _backgroundColor() {
      return BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          Theme.of(context).primaryColorLight,
          Theme.of(context).primaryColorDark.withOpacity(0.7),
          Theme.of(context).primaryColorDark,

        ],
            stops: [0.1,0.35,0.9],
            begin: Alignment.topRight, end: Alignment.bottomCenter),
      );
    }
    return Container(
      decoration: _backgroundColor(),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Stack(
          children: [
            _title(),
            _gospelList(),
            _bottom(),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }
}
