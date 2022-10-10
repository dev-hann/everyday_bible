import 'package:everydaybible/enum/loop_mode.dart';
import 'package:everydaybible/models/quite_time_duration.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/use_case/use_case.dart';

class AudioUseCase extends UseCase<AudioRepo> {
  AudioUseCase(super.repo);

  Stream<QuiteTimeDuration> durationStream() {
    return repo.durationStream();
  }

  Future setLoopMode(LoopMode mode) {
    return repo.setLoopMode(mode.index);
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

  double getVolume() {
    return repo.getVolume();
  }

  Future setVolume(double value) {
    return repo.setVolume(value);
  }
}
