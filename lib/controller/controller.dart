import 'package:audioplayers/audioplayers.dart';
import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/utils/bible_audio_player.dart';
import 'package:everydaybible/utils/bible_web_parser.dart';
import 'package:flutter/material.dart';

class BibleController extends ChangeNotifier {
  static const _bibleAddress = "https://sum.su.or.kr:8888/bible/today";

  Bible _bible;

  BibleWebParser _bibleWebParser = BibleWebParser();

  BibleAudioPlayer _bibleAudioPlayer = BibleAudioPlayer();

  DateTime get dateTime => _bible.dateTime;

  String get title => _bible.title;

  String get subTitle => _bible.subTitle;

  Map<int, String> get gospels => _bible.gospel;

  int get totalDuration => _totalDuration;
  int _totalDuration = 0;

  Future loadData() async {
    print("Loading Today Bible Data..");
    await _bibleWebParser.connectWith(_bibleAddress);
    _setData();
    print("Load Completed!");
    _audioPlayerInit();
  }

  void _setData() {
    print("Set Data..");
    _bible = Bible(
      title: _bibleWebParser.todayTitle,
      subTitle: _bibleWebParser.todaySubtitle,
      audio: _bibleWebParser.todayAudio,
      gospel: _bibleWebParser.todayGospel,
    );
  }

  Future _audioPlayerInit() async {
   /* await audioPlay().whenComplete(()async{
      await audioStop();
    } );
    _totalDuration = await _bibleAudioPlayer.totalDuration;*/
  }

  Future audioPlay() async {
    await _bibleAudioPlayer.play(_bible.audio);
  }

  Future audioPause() async {
    await _bibleAudioPlayer.pause();
  }

  Future audioStop() async {
    await _bibleAudioPlayer.stop();
  }

  Future audioDispose() async {
    await _bibleAudioPlayer.dispose();
  }

  Stream audioDuration() {
    //  return _bibleAudioPlayer.durationChanged;
  }
}
