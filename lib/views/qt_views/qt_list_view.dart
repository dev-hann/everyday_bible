import 'package:everydaybible/controllers/qt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QTListView extends StatelessWidget {
  const QTListView();

  Widget _listView(Map<String, String> map) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: kToolbarHeight*0.8,),
      itemCount: map.length,
      itemBuilder: (_, index) {
        Widget _gospelBox(MapEntry<String, String> gospel) {
          Widget _sectionLine(String index) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(index),
                ),
                Expanded(
                    child: Divider(
                  color: Colors.white70,
                ))
              ],
            );
          }

          Widget _sectionText(String text) {
            return Text(text);
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_sectionLine(gospel.key), _sectionText(gospel.value)],
            ),
          );
        }

        return _gospelBox(map.entries.toList()[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<QTController>(builder: (_controller) {
      return ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.transparent],
            stops: [0, 0.1],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: _listView(_controller.selectedQT!.gospels),
      );
    });


  }
}
