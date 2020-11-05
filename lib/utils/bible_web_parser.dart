import 'package:everydaybible/models/bible.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';

class BibleWebParser {

  static const _bibleAddress = "https://sum.su.or.kr:8888/bible/today";

  Document _document;

  String get todayTitle => _parseByID("bible_text").text.trim();

  String get todaySubtitle => _parseByID('bibleinfo_box').text.trim();

  String get todayAudio => _parseByID("video").children[0].attributes['src'];

  Map<int, String> get todayGospel => _parseGospelsByID('body_list');

  String get todayDateTime => DateFormat('yyyy.MM.dd').format(DateTime.now());


  Future<Bible> get bible async{
    print("Start Loading from Today Data!");
    await _init();
    return Bible(
        dateTime: this.todayDateTime,
        title: this.todayTitle,
        subTitle: this.todaySubtitle,
        gospel: this.todayGospel,
        audio: this.todayAudio
    );
  }



  Future _init() async {
    http.Response _res = await http.get(_bibleAddress);
    _document = parse(_res.body);
  }

  Element _parseByID(String iD) {
    return _document.getElementById(iD);
  }

  Map<int, String> _parseGospelsByID(String id) {
    Map<int, String> _res = Map();
    int _num;
    String _text;
    _document.getElementById(id).children.forEach((element) {
      element.children.forEach((element) {
        if (element.className == 'num') {
          _num = int.tryParse(element.text.trim());
        }
        if (element.className == 'info') {
          _text = element.text.trim();
        }
      });
      _res[_num] = _text;
    });
    return _res;
  }


}
