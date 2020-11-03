
import 'package:flutter/material.dart';

class SpreadingAnimation extends CustomPainter{
  SpreadingAnimation({this.animation,this.beginPos,this.color:Colors.white});
  final double animation;
  final Alignment beginPos;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()
      ..color = color
      ..strokeWidth=3;

    canvas.drawCircle(beginPos.alongSize(size), 2*animation*size.height, _paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
      return true;
  }
}