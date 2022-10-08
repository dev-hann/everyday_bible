import 'package:everydaybible/models/qt_duration.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/use_case/use_case.dart';

class AudioUseCase extends UseCase<AudioRepo> {
  AudioUseCase(super.repo);

  Stream<QTDuration> durationStream() {
    return repo.durationStream();
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
