import 'package:audio_service/audio_service.dart';
import 'package:everydaybible/controllers/qt_controller.dart';
import 'package:everydaybible/view_models/qt_view_models/qt_audio_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'qt_audio_title_view.dart';

class QTAudioView extends StatefulWidget {
  @override
  _QTAudioViewState createState() => _QTAudioViewState();
}

class _QTAudioViewState extends State<QTAudioView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late QTAudioViewModel _viewModel;

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
    return const QTAudioTitle();
  }

  Widget _expandedButton() {
    return GestureDetector(
      onTap: _viewModel.onTapExpandedButton,
      child: Container(
        decoration: BoxDecoration(
            color: Get.theme.primaryColorDark,
            borderRadius: BorderRadius.all(Radius.circular(100))),
        padding: EdgeInsets.all(5),
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _viewModel.expandedButtonController,
        ),
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

  Widget _expandPlayer() {
    Widget _durationText() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _currentDurationText(),
          _totalDurationText(),
        ],
      );
    }

    Widget _slider()  {

      return Slider(
        max: _viewModel.totalSliderValue,
        value: _viewModel.currentSliderValue,
        onChangeStart: _viewModel.sliderOnChangeStart,
        onChangeEnd: _viewModel.sliderOnChangeEnd,
        onChanged: _viewModel.sliderOnChanged,
      );
    }

    Widget _buttons() {
      Widget _stepBackButton() {
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
        Color? _iconColor = _viewModel.isRepeatMode ? null : Colors.grey;
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
          _stepBackButton(),
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

    return SingleChildScrollView(
      padding: EdgeInsets.all(15),
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

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _viewModel.isLoading,
      child: Card(
        child: _viewModel.isMiniMode ? _miniPlayer() : _expandPlayer(),
      ),
    );
  }
}
