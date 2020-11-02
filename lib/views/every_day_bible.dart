import 'package:everydaybible/models/bible.dart';
import 'package:flutter/material.dart';

class EveryDayBible extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EveryDayBibleState();
  }
}

class _EveryDayBibleState extends State<EveryDayBible>{
Bible _bible = Bible();

Widget _title (){
  return Text("${_bible.title}");
}
    Widget _contents(){
      return ListView(
        children: _bible.contents.entries.map((e) => ListTile(leading: Text("${e.key}"),title: Text("${e.value}"),)).toList(),

      );
    }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: _title(),
        ),
        body: _contents(),
      );

  }

}
