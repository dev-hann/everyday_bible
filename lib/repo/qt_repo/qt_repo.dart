library qt_repo;

import 'package:everydaybible/data_base/service/audio_service.dart';
import 'package:everydaybible/data_base/service/qt_service.dart';
import 'package:everydaybible/repo/repo.dart';
part 'qt_impl.dart';

abstract class QTRepo extends Repo {
  Future<dynamic> requestTitle(String dateTime);
  Future<dynamic> requestQT(String dateTime);



  // Audio
  Stream<Duration> durationStream();
  Stream<Duration> positionStream();

  Future loadAudio(String audioURL);
  Future playAudio();
  Future pauseAudio();
  Future seekAudio(Duration duration);
}
