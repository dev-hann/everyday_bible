part of qt_repo;

class QTImpl extends QTRepo {
  final QTService service = QTService();
  final AudioPlayer player = AudioPlayer();
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

  // TODO: get duration.
  @override
  Future<Duration?> loadAudio(String audioURL) async {
    await player.setSourceUrl(audioURL);
    return await player.getDuration();
  }

  @override
  Future pauseAudio() {
    return player.pause();
  }

  @override
  Future playAudio() {
    return player.resume();
  }

  @override
  Future seekAudio(Duration duration) {
    return player.seek(duration);
  }
}
