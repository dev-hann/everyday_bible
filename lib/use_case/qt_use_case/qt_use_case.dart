import 'package:everydaybible/models/quite_time.dart';
import 'package:everydaybible/models/quite_time_format.dart';
import 'package:everydaybible/repo/qt_repo/qt_repo.dart';
import 'package:everydaybible/use_case/use_case.dart';

class QTUseCase extends UseCase<QTRepo> {
  QTUseCase(super.repo);

  Future<QuiteTime> requestQT(QuiteTimeFormat dateTime) async {
    final formatDateTime = dateTime.toString();
    return QuiteTime.fromMap(
      titleJson: await repo.requestTitle(formatDateTime),
      contentsJson: await repo.requestQT(formatDateTime),
    );
  }

  Stream<Duration?> durationStream() {
    return repo.durationStream();
  }

  Stream<Duration> positionStream() {
    return repo.positionStream();
  }

  Future loadAudio(String audioURL) {
    return repo.loadAudio(audioURL);
  }

  Future playAudio() {
    return repo.playAudio();
  }

  Future pauseAudio() {
    return repo.pauseAudio();
  }

  Future seekAudio(Duration duration) {
    return repo.seekAudio(duration);
  }
}
