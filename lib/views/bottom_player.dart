import 'package:everydaybible/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:provider/provider.dart';

class BottomPlayer extends StatefulWidget {
  BottomPlayer({this.titleAnimation});
  final double titleAnimation;
  @override
  State<StatefulWidget> createState() {
    return _BottomPlayerState();
  }
}

class _BottomPlayerState extends State<BottomPlayer>
    with TickerProviderStateMixin {
  AnimationController _playButtonAnimation;
  AnimationController _expandButtonAnimation;
  BibleController _bibleController;

  void initState() {
    super.initState();
    _playButtonAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _expandButtonAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  Widget _playBtn() {
    return IconButton(
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
    );
  }

  Widget _progressText() {
    return Text(
        "${_bibleController.currentDuration} / ${_bibleController.totalDuration}");
  }

  Widget _title() {
    return Text(
      _bibleController.title,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _expandBtn() {
    return IconButton(
      onPressed: () {
        _expandButtonAnimation.isCompleted
            ? _expandButtonAnimation.reverse()
            : _expandButtonAnimation.forward();
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _expandButtonAnimation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _bibleController = Provider.of<BibleController>(context);


    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _playBtn(),
          _progressText(),
          _title(),
          _expandBtn(),
        ],
      ),
    );
  }
}
