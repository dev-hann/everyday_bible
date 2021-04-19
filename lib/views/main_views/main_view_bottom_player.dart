part of views;

class BottomAudioPlayer extends StatefulWidget {
  @override
  _BottomAudioPlayerState createState() => _BottomAudioPlayerState();
}

class _BottomAudioPlayerState extends State<BottomAudioPlayer>
    with TickerProviderStateMixin {
  late BottomAudioViewModel _viewModel;
  final bible  = Provider.of<BibleDatabase>(Get.context!);

  void initState() {
    super.initState();
    _viewModel = BottomAudioViewModel(
      bibleDatabase: bible
    )..addListener(_listener);

    _viewModel.initBottomPlayer(vsync: this);
  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  void didUpdateWidget(oldWidget) {
    // if (this.widget.title != oldWidget.title) {
    //   _viewModel.removeListener(_listener);
    //   _viewModel = BottomAudioViewModel(
    //       bibleDatabase: bible,
    //   )..addListener(_listener);
    //
    //   _viewModel.initBottomPlayer(vsync: this);
    // }
    // super.didUpdateWidget(oldWidget);
  }

  Widget _playButton({double? iconSize}) {
    Widget _loading() {
      return SizedBox(
          height: kToolbarHeight/2,
          width: kToolbarHeight/2,
          child: const CircularProgressIndicator());
    }
    Widget _button() {
      return AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        progress: (_viewModel.playButtonAnimation)!,
        size: iconSize,
      );
    }

    if(_viewModel.isLoading) return _loading() ;
    return GestureDetector(
      onTap: _viewModel.onTapPlayButton,
      child: Container(
        decoration: BoxDecoration(
            color: Get.theme.primaryColorDark,
            borderRadius: BorderRadius.all(Radius.circular(100))),
        padding: EdgeInsets.all(5),
        child: _button(),
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
      _viewModel.title,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _durationText() {
    return Text(_viewModel.audioDurationText);
  }

  Widget _miniModeWidget() {
    return GestureDetector(
      onTap: _viewModel.onTapMoreButton,
      child: ColoredBox(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _playButton(),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(child: _titleText()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _durationText(),
              ),
              _moreButton(),
            ],
          ),
        ),
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
    return IgnorePointer(
      ignoring: _viewModel.isLoading,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
        height: _viewModel.playerHeight,
        color: Get.theme.primaryColorDark,
        child: Card(child: _child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _player();
  }
}
