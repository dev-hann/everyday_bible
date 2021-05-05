
part of qt_lib;

class QTAudioView extends StatefulWidget {
  @override
  _QTAudioViewState createState() => _QTAudioViewState();
}

class _QTAudioViewState extends State<QTAudioView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late QTAudioViewModel _viewModel;
  final GlobalKey _expandedKey=GlobalKey();
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    AudioService.connect();

    final QTController _controller = Get.find();
    _viewModel = QTAudioViewModel(_controller);
    _viewModel.initAnimation(this);
    _viewModel.addListener(_listener);
    _viewModel.initAudio();

  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  void dispose() {
    _viewModel.dispose();
    AudioService.disconnect();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AudioService.connect();
        break;
      case AppLifecycleState.paused:
        AudioService.disconnect();
        break;
      default:
        break;
    }
  }

  @override
  Future<bool> didPopRoute() async {
    AudioService.disconnect();
    return false;
  }

  Widget _titleWidget() {
    return Text(
      _viewModel.title,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _expandedButton() {

    IconData _icon = _viewModel.isMiniMode?Icons.menu:Icons.close;
    return GestureDetector(
      onTap: _viewModel.onTapExpandedButton,
      child: Container(
        decoration: BoxDecoration(
            color: Get.theme.primaryColorDark,
            borderRadius: BorderRadius.all(Radius.circular(100))),
        padding: EdgeInsets.all(5),
        child: Icon(_icon,color: Colors.white,),
      ),
    );
  }

  Widget _playButton({double? iconSize}) {
    if (_viewModel.isLoading) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
    return GestureDetector(
      onTap: _viewModel.onTapPlayButton,
      child: Container(
        decoration: BoxDecoration(
            color: Get.theme.primaryColorDark,
            borderRadius: BorderRadius.all(Radius.circular(100))),
        padding: EdgeInsets.all(5),
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _viewModel.playButtonController,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _currentDurationText() {
    return Text("${_viewModel.currentDurationText}");
  }

  Widget _totalDurationText() {
    return Text("${_viewModel.totalDurationText}");
  }

  Widget _miniPlayer() {
    Widget _durationText() {
      return Row(
        children: [
          _currentDurationText(),
          Text(" / "),
          _totalDurationText(),
        ],
      );
    }

    return GestureDetector(
      onTap: _viewModel.onTapExpandedButton,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _playButton(),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: _titleWidget(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: _durationText(),
            ),
            _expandedButton(),
          ],
        ),
      ),
    );
  }

  ///[todo] get height animatedContainer
  Widget _expandPlayer() {
    //
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   print(_expandedKey.currentContext!.size);
    //   playerHeight=_expandedKey.currentContext!.size!.height;
    //   setState(() {
    //
    //   });
    // });

    Widget _durationText() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _currentDurationText(),
          _totalDurationText(),
        ],
      );
    }

    Widget _slider() {
      return Slider(
        activeColor: Get.theme.primaryColorDark,
        inactiveColor: Get.theme.primaryColor.withOpacity(0.7),
        max: _viewModel.totalSliderValue,
        value: _viewModel.currentSliderValue,
        onChangeStart: _viewModel.sliderOnChangeStart,
        onChangeEnd: _viewModel.sliderOnChangeEnd,
        onChanged: _viewModel.sliderOnChanged,
      );
    }

    Widget _buttons() {
      Widget _soundControlButton() {
        return GestureDetector(
          child: FaIcon(FontAwesomeIcons.volumeUp),
          onTap: _viewModel.onTapVolumeControl,
        );
      }

      Widget _forwardButton() {
        return GestureDetector(
          child: Icon(FontAwesomeIcons.forward),
          onTap: _viewModel.onTapAudioForward,
        );
      }

      Widget _rewindButton() {
        return GestureDetector(
            onTap: _viewModel.onTapAudioRewind,
            child: Icon(FontAwesomeIcons.backward));
      }

      Widget _repeatButton() {
        Color? _iconColor = _viewModel.isRepeatMode ? null : Colors.black26;
        return GestureDetector(
          onTap: _viewModel.onTapRepeat,
          child: Icon(
            Icons.repeat_one_outlined,
            size: 40,
            color: _iconColor,
          ),
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _soundControlButton(),
          _rewindButton(),
          _playButton(iconSize: 50),
          _forwardButton(),
          _repeatButton()
        ],
      );
    }

    Widget _appBar() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _expandedButton(),
        ],
      );
    }

    return Padding(
      // key: _expandedKey,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
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
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _viewModel.isLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: IconTheme(
          data: IconThemeData(color: Get.theme.primaryColor),
          child: DefaultTextStyle(
            style: Get.textTheme.bodyText2!.copyWith(
                color: Get.theme.primaryColorDark, fontWeight: FontWeight.w900),
            child: GlassContainer(
              opacity: 0.4,
              child: _viewModel.isMiniMode ? _miniPlayer() : _expandPlayer(),
            ),
          ),
        ),
      ),
    );
  }
}
