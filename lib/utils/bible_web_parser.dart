import 'package:everydaybible/models/bible.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';

class BibleWebParser {
 final String _titleID ="bible_text";
 final String _subTitleID = 'bibleinfo_box';
 final String _audioID = "video";
 final String _gospelID = "body_list";

  Future<Bible> get bible async {

    print("Start Loading from Today Data!");
    Document _doc= await _init();

    return Bible(
      dateTime: DateFormat('yyyy.MM.dd').format(DateTime.now()),
      title: _parseByID(_doc, _titleID).text.trim(),
      subTitle: _parseByID(_doc, _subTitleID).text.trim(),
      gospel: _parseGospelsByID(_doc,_gospelID),
      audio: _parseByID(_doc,_audioID).children[0].attributes['src'],
    );
  }
///"https://sum.su.or.kr:8888/bible/today"
  Future<Document> _init() async {
    Uri _uri = Uri.https("sum.su.or.kr:8888", "/bible/today");
    http.Response _res = await http.get(_uri);
    return parse(_res.body);
  }

  Element _parseByID(Document _document ,String iD) {
    return _document.getElementById(iD);
  }

  Map<int, String> _parseGospelsByID(Document _document,String id) {
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
