library audio_repo;

import 'dart:async';

import 'package:everydaybible/model/audio/audio_state.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:just_audio/just_audio.dart';

part 'audio_impl.dart';

abstract class AudioRepo extends Repo {
  Stream<AudioState> stateStream();

  Future setLoopMode(LoopMode loopMode);

  Future setVolume(double value);

  Future loadAudio(String audioURL);
  Future playAudio();
  Future pauseAudio();
  Future seekAudio(Duration duration);

  Future stopAudio();
}
