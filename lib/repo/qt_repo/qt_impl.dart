part of qt_repo;

class QTImpl extends QTRepo {
  final QTService service = QTService();
  final AudioService audioService = AudioService();
  final StreamController<QTDuration> _durationStream =
      StreamController.broadcast();
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  @override
  Future init() async {
    audioService.durationStream().listen((event) {
      if (event != null) {
        duration = event;
        _durationStream.add(
          QTDuration(position: position, duration: duration),
        );
      }
    });
    audioService.positionStream().listen((event) {
      position = event;
      _durationStream.add(
        QTDuration(position: position, duration: duration),
      );
    });
  }

  @override
  Future requestTitle(String dateTime) async {
    final res = await service.requestTitle(dateTime);
    return res.data;
  }

  @override
  Future requestQT(String dateTime) async {
    final res = await service.requestQT(dateTime);
    return res.data;
  }

  @override
  Future loadAudio(String audioURL) {
    return audioService.loadAudio(audioURL);
  }

  @override
  Future pauseAudio() {
    return audioService.pause();
  }

  @override
  Future playAudio() {
    return audioService.play();
  }

  @override
  Future seekAudio(Duration duration) {
    return audioService.seek(duration);
  }

  @override
  Stream<QTDuration> durationStream() {
    return _durationStream.stream;
  }
}
