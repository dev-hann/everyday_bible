part of views;

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
  String _currentDuration="00:00";
  Widget _mode;

  void initState() {
    super.initState();
    _playButtonAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _expandButtonAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  Widget _expandBtn() {
    return IconButton(
      onPressed: () {
        if (_expandButtonAnimation.isCompleted) {
          _expandButtonAnimation.reverse();
          _mode = _miniMode();
        } else {
          _expandButtonAnimation.forward();
          _mode = _expandMode();
        }
        setState(() {});
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _expandButtonAnimation,
      ),
    );
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

  Widget _miniMode() {
    Widget _progressText() {
      return Text(
          "$_currentDuration / ${_bibleController.totalDuration}");
    }

    Widget _title() {
      return Text(
        _bibleController.title,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _playBtn(),
        _progressText(),
        _title(),
        _expandBtn(),
      ],
    );
  }

  Widget _expandMode() {
    Widget _timeLine() {
      Widget _timeLineText() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$_currentDuration"),
            Text("${_bibleController.totalDuration}")
          ],
        );
      }

      Widget _timeLineBar() {
        return Slider(value: 0.1, onChanged: (value) {});
      }

      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [_timeLineText(), _timeLineBar()],
        ),
      );
    }

    Widget _controlButtons() {
      Widget _loopBtn(){
        return IconButton(icon: Icon(Icons.loop), onPressed: (){});
      }
      Widget _previousBtn(){
        return IconButton(
          onPressed: (){},
          icon: Icon(Icons.skip_previous),
        );
      }
      Widget _nextBtn(){
        return IconButton(
          onPressed: (){},
          icon: Icon(Icons.skip_next),
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _loopBtn(),
          _previousBtn(),
          _playBtn(),
          _nextBtn(),
          _expandBtn(),
        ],
      );
    }

    return Column(
      children: [
        _timeLine(),
        _controlButtons(),
      ],
    );
  }

  Widget _player(){
    _currentDuration = Provider.of<BibleController>(context).currentDuration;
    return AnimatedSize(
      alignment: Alignment.bottomCenter,
      vsync: this,
      duration: Duration(milliseconds:100),
      child: Card(
        child: _mode??_miniMode()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _bibleController = Provider.of<BibleController>(context);
    return _player();
  }
}
