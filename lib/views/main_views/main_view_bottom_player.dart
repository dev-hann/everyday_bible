part of views;

class MainViewBottomPlayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainViewBottomPlayerState();
  }
}

class _MainViewBottomPlayerState extends State<MainViewBottomPlayer>
    with TickerProviderStateMixin {
  BibleController _bibleController;
  BibleAudioPlayer _audioPlayer;
  BibleNotification _bibleNotification;
  AnimationController _expandButtonAnimation;
  AnimationController _playButtonAnimation;

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  bool _isMiniMode = true;
  bool _onChanging = false;


  void initState() {
    super.initState();



    _bibleController = Provider.of<BibleController>(context,listen: false);

    _audioPlayer = BibleAudioPlayer(
      url: _bibleController.audio,
      currentDuration: _current,
      totalDuration: _total,
    );

    _playButtonAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _expandButtonAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

  }

  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  void _current(Duration duration) {
    if (!_onChanging) {
      if (_currentDuration != duration) {
        _currentDuration = duration;
        setState(() {});
      }
    }
  }

  void _total(Duration duration) {
    if (_totalDuration != duration) {
      _totalDuration = duration;
      setState(() {});
    }
  }

  Widget _expandBtn() {
    return IconButton(
      onPressed: () {
        _bibleNotification = BibleNotification()..showMediaStyleNotification();

      if (_expandButtonAnimation.isCompleted) {
          _expandButtonAnimation.reverse();
        } else {
          _expandButtonAnimation.forward();
        }
        setState(() {
          _isMiniMode = !_isMiniMode;
        });
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
          _audioPlayer.pause();
        } else {
          _playButtonAnimation.forward();
          _audioPlayer.play();
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
  Widget _title() {
    return Text(
     "",
      // "${_bibleController.title}",
      overflow: TextOverflow.ellipsis,
    );
  }
  Widget _miniMode() {
    Widget _progressText() {
      return Text(
          "${_audioPlayer.dateTimeFrom(_currentDuration)} / ${_audioPlayer.dateTimeFrom(_totalDuration)}");
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
            Text("${_audioPlayer.dateTimeFrom(_currentDuration)}"),
            _title(),
            Text("${_audioPlayer.dateTimeFrom(_totalDuration)}")
          ],
        );
      }

      Widget _timeLineBar() {
        double _lineValue =
            _currentDuration.inSeconds / _totalDuration.inSeconds;

        return Slider(
          value: _lineValue,
          onChanged: (value) {
            _currentDuration =
                Duration(seconds: (_totalDuration.inSeconds * value).round());
            setState(() {});
          },
          onChangeStart: (_) {
            _onChanging = true;
            setState(() {});
          },
          onChangeEnd: (value) {
            _audioPlayer.seek(_currentDuration);
            _onChanging = false;
            setState(() {});
          },
        );
      }

      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [_timeLineText(), _timeLineBar()],
        ),
      );
    }

    Widget _controlButtons() {
      Widget _loopBtn() {
        return IconButton(icon: Icon(Icons.loop), onPressed: () {});
      }

      Widget _previousBtn() {
        return IconButton(
          onPressed: () {
            Duration _res = Duration.zero;
            if (_currentDuration.inSeconds > 5) {
              _res = _currentDuration - Duration(seconds: 5);
            }
            _audioPlayer.seek(_res);
            setState(() {});
          },
          icon: Icon(Icons.skip_previous),
        );
      }

      Widget _nextBtn() {
        return IconButton(
          onPressed: () {
            Duration _res = _totalDuration;
            final _temp = _currentDuration + Duration(seconds: 5);
            if (_temp < _res) {
              _res = _temp;
            }
            _audioPlayer.seek(_res);
            setState(() {});
          },
          icon: Icon(Icons.skip_next),
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _player() {
    return AnimatedSize(
      alignment: Alignment.bottomCenter,
      vsync: this,
      duration: Duration(milliseconds: 200),
      child: Card(child: _isMiniMode ? _miniMode() : _expandMode()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _player();
  }
}
