import 'package:everydaybible/models/bible.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

class BibleParser {
  static const _bibleAddress = "https://sum.su.or.kr:8888/bible/today";
  String _audio;
  String _title;
  Map<int,String> _contents;

  get title=>_title;
  get audio=>_audio;
  get contents => _contents;

  Future init() async {
    print("Loading Today Bible Data...");
    http.Response _res = await http.get(_bibleAddress);
    Document _data = parse(_res.body);

    _data.body.children.forEach((sub) {
      if (sub.className == "sub") {
        sub.children.forEach((_data) {
          if (_data.className == "today_contemplation") {
            _data.children.forEach((element) {
              if (element.className == 'sec02') {
                element.children.forEach((element) {
                  if (element.id == 'mainView_2') {
                    element.children.forEach((element) {
                      if (element.id == 'font_uparea02') {
                        element.children.forEach((element) {
                          if (element.className == 'select_date') {
                            element.children.forEach((element) {
                              if (element.id == 'bible_text') {
                                _title = element.text.trim();
                              }
                            });
                          }
                          if (element.id == 'body_list') {
                            element.children.forEach((element) {
                              int _num;
                              String _content;
                              _num =
                                  int.tryParse(element.children[0].innerHtml);
                              _content = element.children[1].innerHtml;
                             this._contents[_num] = _content;
                            });
                          }
                        });
                      }
                      if (element.className == "audio_area") {
                        element.children.forEach((element) {
                          if (element.className == "player_area") {
                            element.children.forEach((element) {
                              if (element.className == 'player') {
                                element.children.forEach((element) {
                                  if (element.id == "video") {
                                  element.children.forEach((element) {
                                    _audio=element.attributes['src'];
                                  });
                                  }
                                });
                              }
                            });
                          }
                        });
                      }
                    return;
                    });
                  }
                });
              }
            });
          }
        });
      }
    });
    print("Load Complete!!");
  }

  Bible toBible(){
      Bible _res = Bible();
      _res.title = this.title;
      _res.audio=this.audio;
      _res.contents = this.contents;
    return _res;
  }
}
