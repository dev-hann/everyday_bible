part of views;

class BottomAudioPlayer extends StatefulWidget {
  BottomAudioPlayer({
   required this.audioAsset,
   required this.title,
  });

  final String title;
  final String audioAsset;

  @override
  _BottomAudioPlayerState createState() => _BottomAudioPlayerState();
}

class _BottomAudioPlayerState extends State<BottomAudioPlayer>
    with TickerProviderStateMixin {
late  BottomAudioViewModel _viewModel;

  void initState() {
    super.initState();
    _viewModel = BottomAudioViewModel(widget.audioAsset)
      ..addListener(() {
        setState(() {});
      });
    _viewModel.initBottomPlayer(vsync: this);
  }

  Widget _playButton({double? iconSize}) {
    return GestureDetector(
      onTap: _viewModel.onTapPlayButton,
      child: Container(
        decoration: BoxDecoration(
            color: Get.theme.primaryColorDark,
            borderRadius: BorderRadius.all(Radius.circular(100))),
        padding: EdgeInsets.all(5),
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _viewModel.playButtonAnimation,
          size: iconSize,
        ),
      ),
    );
  }

  Widget _moreButton() {
    return GestureDetector(
      onTap: _viewModel.onTapMoreButton,
      child: Container(
        decoration: BoxDecoration(
            color: Get.theme.primaryColorDark,
            borderRadius: BorderRadius.all(Radius.circular(100))),
        padding: EdgeInsets.all(5),
        child: Icon(_viewModel.isMiniMode ? Icons.menu : Icons.close),
      ),
    );
  }

  Widget _titleText() {
    return Text(
      widget.title,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _durationText() {
    return Text(_viewModel.audioDurationText);
  }

  Widget _miniModeWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _playButton(),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                  child: _titleText()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _durationText(),
          ),
          _moreButton(),
        ],
      ),
    );
  }

  Widget _moreModeWidget() {
    Widget _slider() {
      return Slider(
        max: _viewModel.totalSliderValue,
        min: 0.0,
        value: _viewModel.currentSliderValue,
        onChangeStart: _viewModel.sliderOnChangeStart,
        onChangeEnd: _viewModel.sliderOnChangeEnd,
        onChanged: _viewModel.sliderOnChanged,
      );
    }

    Widget _durationText() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_viewModel.currentDurationText),
          Text(_viewModel.totalDurationText),
        ],
      );
    }

    Widget _buttons() {
      Widget _forwardButton() {
        return IconButton(
          icon: Icon(Icons.fast_forward),
          onPressed: _viewModel.onTapAudioForward,
        );
      }

      Widget _rewindButton() {
        return IconButton(
          icon: Icon(Icons.fast_rewind),
          onPressed: _viewModel.onTapAudioRewind,
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _rewindButton(),
          _playButton(iconSize: 50),
          _forwardButton()
        ],
      );
    }

    Widget _appBar() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _moreButton(),
        ],
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _appBar(),
          _slider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _durationText(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: _buttons(),
          ),
        ],
      ),
    );
  }

  Widget _player() {
    Widget _child =
        (_viewModel.isMiniMode) ? _miniModeWidget() : _moreModeWidget();

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.bounceInOut,
      height: _viewModel.playerHeight,
      color: Get.theme.primaryColorDark,
      child: Card(child: _child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _player();
  }
}
