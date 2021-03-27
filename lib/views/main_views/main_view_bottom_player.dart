part of views;

class BottomAudioPlayer extends StatefulWidget {
  BottomAudioPlayer({
    this.miniMode = true,
    this.audioAsset,
    this.title,
  });
  final String title;
  final String audioAsset;
  final bool miniMode;

  @override
  _BottomAudioPlayerState createState() => _BottomAudioPlayerState();
}

class _BottomAudioPlayerState extends State<BottomAudioPlayer>
    with TickerProviderStateMixin {
  BottomAudioViewModel _viewModel;

  AnimationController _playButtonAnimation;
  AnimationController _moreButtonAnimation;

  bool get _isPlaying => _playButtonAnimation.value == 1;

  void initState() {
    super.initState();
    _viewModel = BottomAudioViewModel(widget.audioAsset)
      ..addListener(() {
        setState(() {});
      });
    _viewModel.initAudio();

    _playButtonAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _moreButtonAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  Widget _playButton() {
    return IconButton(
      onPressed: () {
        if (_isPlaying) {
          _playButtonAnimation.reverse();
          _viewModel.pauseAudio();
        } else {
          _playButtonAnimation.forward();
          _viewModel.playAudio();
        }
      },
      icon: CircleAvatar(
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _playButtonAnimation,
        ),
      ),
    );
  }

  Widget _moreButton() {
    return IconButton(
      onPressed: () {
        if (_moreButtonAnimation.value == 0) {
          _moreButtonAnimation.forward();
        } else {
          _moreButtonAnimation.reverse();
        }
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _moreButtonAnimation,
      ),
    );
  }

  Widget _titleText() {
    return Text(
      widget.title??"",
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _durationText() {
    return Text(_viewModel.audioDurationText??"00:00 / 00:00");
  }

  Widget _miniModeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _playButton(),
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: _titleText(),
        )),
        _durationText(),
        _moreButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Get.theme.primaryColorDark,
      duration: Duration(milliseconds: 1000),
      height: widget.miniMode ? kToolbarHeight : kToolbarHeight * 2,
      child: Card(child: _miniModeWidget()),
    );
  }
}
