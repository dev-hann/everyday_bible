import 'package:audioplayers/audioplayers.dart';
import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/utils/bible_audio_player.dart';
import 'package:everydaybible/utils/bible_database.dart';
import 'package:everydaybible/utils/bible_web_parser.dart';
import 'package:flutter/material.dart';

class BibleController extends ChangeNotifier {

  final BibleAudioPlayer _bibleAudioPlayer = BibleAudioPlayer();

  final BibleDatabase _bibleDatabase = BibleDatabase();

  Bible _bible;

  String get title => _bible.title;

  String get subTitle => _bible.subTitle;

  Map<int, String> get gospels => _bible.gospel;

  String get totalDuration => dateTimeFrom(_totalDuration);

  String get currentDuration => dateTimeFrom(_currentDuration);

  Duration _totalDuration = Duration.zero;

  Duration _currentDuration = Duration.zero;

  String dateTimeFrom(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
    //   return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future init() async {
    if (_bible == null) {
      print("Loading Today Bible Data..");
      await _bibleDatabase.init();
      _bible = await _bibleDatabase.todayData();
      print("Load Completed!");
     // await _audioPlayerInit();
    }
  }


  Future _audioPlayerInit() async {
    await _bibleAudioPlayer.setURL(_bible.audio);
    await _totalDurationStream();
    await _currentDurationStream();
  }

  Future _currentDurationStream() async {
    _bibleAudioPlayer.currentDuration.listen((event) {
      _currentDuration = event;
      notifyListeners();
    });
  }

  Future _totalDurationStream() async {
    _bibleAudioPlayer.totalDuration.listen((event) {
      _totalDuration = event;
    });
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
}
