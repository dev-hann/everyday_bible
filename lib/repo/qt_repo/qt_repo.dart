library qt_repo;

import 'dart:async';

import 'package:everydaybible/data_base/service/audio_service.dart';
import 'package:everydaybible/data_base/service/qt_service.dart';
import 'package:everydaybible/models/qt_duration.dart';
import 'package:everydaybible/repo/repo.dart';
part 'qt_impl.dart';

typedef DurationCallback = Function(Duration position, Duration duration);

abstract class QTRepo extends Repo {
  Future<dynamic> requestTitle(String dateTime);
  Future<dynamic> requestQT(String dateTime);

  // Audio
  Stream<QTDuration> durationStream();

  Future loadAudio(String audioURL);
  Future playAudio();
  Future pauseAudio();
  Future seekAudio(Duration duration);
}
