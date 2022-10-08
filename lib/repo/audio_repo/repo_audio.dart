library audio_repo;

import 'dart:async';

import 'package:everydaybible/data_base/service/audio_service.dart';
import 'package:everydaybible/enum/audio_state.dart';
import 'package:everydaybible/models/qt_duration.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:just_audio/just_audio.dart';

part 'audio_impl.dart';

abstract class AudioRepo extends Repo {
  Stream<QTDuration> durationStream();

  Future loadAudio(String audioURL);
  Future playAudio();
  Future pauseAudio();
  Future seekAudio(Duration duration);
}
