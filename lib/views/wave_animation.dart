import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaveAnimation extends StatefulWidget {
  WaveAnimation({
    this.filledColor: Colors.transparent,
    this.lineColor: Colors.black,
    this.lineBorder: 2.0,
    this.duration: const Duration(seconds: 4),
    this.angle: 0.0,
    this.amplitude: 20,
  });

  final Duration duration;
  final Color filledColor;
  final Color lineColor;
  final double lineBorder;
  final double angle;
  final double amplitude;

  @override
  State<StatefulWidget> createState() {
    return _WaveAnimationState();
  }
}

class _WaveAnimationState extends State<WaveAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  void initState() {
    super.initState();
    double _test = widget.duration.inSeconds * 25.0;
    _animationController = AnimationController(
        duration: widget.duration, upperBound: _test, vsync: this);
    _animationController.addListener(_listener);
    _animationController.repeat();
  }

  void _listener() {
    setState(() {});
  }

  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _Wave(
        animation: _animationController.value,
        lineColor: widget.lineColor,
        filledColor: widget.filledColor,
        lineBorder: widget.lineBorder,
        angle: widget.angle,
        amplitude: widget.amplitude,
      ),
    );
  }
}

class _Wave extends CustomPainter {
  _Wave({
    this.animation,
    this.filledColor,
    this.lineColor,
    this.lineBorder,
    this.angle,
    this.amplitude,
  });

  final double animation;
  final Color filledColor;
  final Color lineColor;
  final double lineBorder;
  final double angle;
  final double amplitude;

  List<Offset> _waves = List();

  double _eachGap = 100 / ScreenUtil().screenWidth;

  List<Offset> _makeWaves(Size _size) {
    List<Offset> _res = List();
    for (double i = -_size.width; i < _size.width * 2; i++) {
      _res.add(Offset(
          i,
          this.amplitude * sin(animation + 0.01 * i) +
              _size.height / 2 -
              (_eachGap * i)));
    }
    return _res;
  }

  Paint _filledPaint() {
    return Paint()
      ..color = filledColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
  }

  Paint _linePaint() {
    return Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineBorder;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _waves = _makeWaves(size);

    for (int i = 0; i < _waves.length - 1; i++) {
      canvas.drawLine(_waves[i], _waves[i + 1], _linePaint());
      canvas.drawLine(
          _waves[i], Offset(_waves[i].dx, size.height), _filledPaint());
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
