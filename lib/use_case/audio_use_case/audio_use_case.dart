import 'package:everydaybible/model/audio/audio_state.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/use_case/use_case.dart';
import 'package:just_audio/just_audio.dart';

class AudioUseCase extends UseCase<AudioRepo> {
  AudioUseCase(super.repo);

  Stream<AudioState> stateStream() {
    return repo.stateStream();
  }

  Future setLoopMode(LoopMode mode) {
    return repo.setLoopMode(mode);
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

  Future setVolume(double value) {
    return repo.setVolume(value);
  }

  Future stopAudio() {
    return repo.stopAudio();
  }
}
