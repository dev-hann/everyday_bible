library audio_repo;

import 'dart:async';

import 'package:everydaybible/data_base/service/audio_service.dart';
import 'package:everydaybible/enum/audio_state.dart';
import 'package:everydaybible/models/quite_time_duration.dart';
import 'package:everydaybible/repo/repo.dart';

part 'audio_impl.dart';

abstract class AudioRepo extends Repo {
  Stream<QuiteTimeDuration> durationStream();

  Future setLoopMode(int index);

  double getVolume();
  Future setVolume(double value);

  Future loadAudio(String audioURL);
  Future playAudio();
  Future pauseAudio();
  Future seekAudio(Duration duration);
}
