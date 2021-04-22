
import 'package:everydaybible/models/bible.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _list=[
  "1-01_genesis.txt",
  "1-02_exodus.txt",
  "1-03_leviticus.txt",
  "1-04_numbers.txt",
  "1-05_deuteronomy.txt",
  "1-06_joshua.txt",
  "1-07_judges.txt",
  "1-08_ruth.txt",
  "1-09_samuel_0.txt",
  "1-10_samuel_1.txt",
  "1-11_kings_0.txt",
  "1-12_kings_1.txt",
  "1-13_chronicles_0.txt",
  "1-14_chronicles_1.txt",
  "1-15_ezra.txt",
  "1-16_nehemiah.txt",
  "1-17_esther.txt",
  "1-18_job.txt",
  "1-19_psalms.txt",
  "1-20_proverbs.txt",
  "1-21_ecclesiastes.txt",
  "1-22_song_of_songs.txt",
  "1-23_isaiah.txt",
  "1-24_jeremiah.txt",
  "1-25_lamentations.txt",
  "1-26_ezekiel.txt",
  "1-27_daniel.txt",
  "1-28_hosea.txt",
  "1-29_joel.txt",
  "1-30_amos.txt",
  "1-31_obadiah.txt",
  "1-32_jonah.txt",
  "1-33_micah.txt",
  "1-34_nahum.txt",
  "1-35_habakkuk.txt",
  "1-36_zephaniah.txt",
  "1-37_haggai.txt",
  "1-38_zechariah.txt",
  "1-39_malachi.txt",
  "2-01_matthew.txt",
  "2-02_mark.txt",
  "2-03_luke.txt",
  "2-04_john.txt",
  "2-05_acts.txt",
  "2-06_romans.txt",
  "2-07_corinthians_0.txt",
  "2-08_corinthians_1.txt",
  "2-09_galatians.txt",
  "2-10_ephesians.txt",
  "2-11_philippians.txt",
  "2-12_colossians.txt",
  "2-13_thessalonians_0.txt",
  "2-14_thessalonians_1.txt",
  "2-15_timothy_0.txt",
  "2-16_timothy_1.txt",
  "2-17_titus.txt",
  "2-18_philemon.txt",
  "2-19_hebrews.txt",
  "2-20_james.txt",
  "2-21_peter_0.txt",
  "2-22_peter_1.txt",
  "2-23_john_0.txt",
  "2-24_john_1.txt",
  "2-25_john_2.txt",
  "2-26_jude.txt",
  "2-27_revelation.txt",
];

class BibleTest extends StatelessWidget {
  void _aa() async {
    final prefix = "assets/bible_db/kor_gg_bible/";
    List<Bible> _bibleList=[];
    for(final _data in _list){
      String _loadData=await rootBundle.loadString(prefix+_data);
      BibleType _type = _data[0]=="1"?BibleType.Old:BibleType.New;

      Bible _tmpBible = Bible(type: _type,title: "",chapterList: []);
      _tmpBible = _writeBible(_tmpBible, _loadData);
      _bibleList.add(_tmpBible);
    }

  }


  Bible _writeBible(Bible _defaultBible,String originData){

    List<String> splitData = originData.split("\n");
    Bible _tmpBible = _defaultBible;

    Chapter _tmpChapter = Chapter(index: 1,verseList: []);
    Verse _tmpVerse = Verse(verse: "");

    splitData.forEach((element) {
      List<String> _tmp =  element.split(" ");

      if(_tmpBible.title=="") {
        ///bible title
        ///
        String bibleTitle;
        try{
          int.parse(_tmp[0].substring(1, 2));
          bibleTitle = _tmp[0].substring(0, 1);
        }catch(e){
          bibleTitle = _tmp[0].substring(0, 2);
        }
        _tmpBible.title=bibleTitle;
      }

      ///chapter index
      String _chapterIndex = _tmp[0].split(":")[0].replaceAll(
          _tmpBible.title, "");
      int chapterIndex = int.parse(_chapterIndex);

      ///verse
      String verse = _tmp.sublist(1).join(" ");

      _tmpVerse  = Verse(verse: verse);


      if(_tmpChapter.index==chapterIndex) {
        _tmpChapter.verseList.add(_tmpVerse);
      }else{
        _tmpBible.chapterList.add(_tmpChapter);
        _tmpChapter = Chapter(index: chapterIndex,verseList: []);
        _tmpChapter.verseList.add(_tmpVerse);
      }

    });
    _tmpBible.chapterList.add(_tmpChapter);


    return _tmpBible;
  }




  @override
  Widget build(BuildContext context) {
    _aa();
    return Container();
  }
}
