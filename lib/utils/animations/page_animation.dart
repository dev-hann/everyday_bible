import 'package:everydaybible/views/every_day_bible.dart';
import 'package:flutter/material.dart';

class FadePageRoute extends PageRoute {
  FadePageRoute({this.builder});

  final WidgetBuilder builder;

  @override
  // TODO: implement barrierColor
  Color get barrierColor => null;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => "";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }

  @override
  // TODO: implement maintainState
  bool get maintainState => true;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 2000);
}
