import 'package:flutter/material.dart';

class FadeAnimation extends StatefulWidget {
  FadeAnimation({
    this.axisDirection: AxisDirection.right,
    this.text,
    this.duration: const Duration(seconds: 1),
  });

  final Duration duration;
  final AxisDirection axisDirection;
  final Text text;

  @override
  State<StatefulWidget> createState() {
    return _FadeAnimationState();
  }
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Text _text;

  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )
      ..forward()
      ..addListener(_listener);
    _text = widget.text;
  }

  void _listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        curve: Curves.easeIn,
        padding: EdgeInsets.only(left: _animationController.value*20),
        duration: Duration.zero,
        child: Opacity(opacity: _animationController.value, child: _text));
  }
}
