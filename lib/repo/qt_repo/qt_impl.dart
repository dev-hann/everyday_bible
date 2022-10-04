part of qt_repo;

class QTImpl extends QTRepo {
  final QTService service = QTService();
  final AudioService audioService = AudioService();
  @override
  Future init() async {}

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
  Future loadAudio(String audioURL) async {
    return audioService.loadAudio(audioURL);
  }

  @override
  Future pauseAudio() {
    return audioService.pause();
  }

  @override
  Future playAudio() {
    return audioService.resume();
  }

  @override
  Future seekAudio(Duration duration) {
    return audioService.seek(duration);
  }

  @override
  Stream<Duration> durationStream() {
    return audioService.durationStream();
  }

  @override
  Stream<Duration> positionStream() {
    return audioService.positionStream();
  }
}
