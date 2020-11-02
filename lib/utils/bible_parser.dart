import 'package:everydaybible/models/bible.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

class BibleParser {
  static const _bibleAddress = "https://sum.su.or.kr:8888/bible/today";
  Bible _bible = Bible();

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
                                _bible.contents[0] = element.text.trim();
                              }
                            });
                          }
                          if (element.id == 'body_list') {
                            element.children.forEach((element) {
                              int _num;
                              String _content;
                             _num = int.tryParse(element.children[0].innerHtml);
                            _content = element.children[1].innerHtml;
                            _bible.contents[_num] = _content;
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
      }
    });
    print("Load Complete!!");
  }
}
