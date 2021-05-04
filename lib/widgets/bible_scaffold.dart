import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BibleScaffold extends StatelessWidget {
  const BibleScaffold({
    this.appBar,
    this.body,
    this.drawer,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar=true,
  });

  final AppBar? appBar;
  final Widget? body;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final bool extendBodyBehindAppBar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      drawer: drawer,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Get.theme.primaryColorLight.withOpacity(0.8),
              Get.theme.primaryColorDark.withOpacity(0.7),
              Get.theme.primaryColorDark,
            ],
            stops: [0.1, 0.35, 0.9],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
