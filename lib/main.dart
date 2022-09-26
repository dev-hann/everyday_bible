import 'package:everydaybible/data_base/data/box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'views/intro_views/intro_lib.dart';

void main() async {
  await LocalBox.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Everyday Bible',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.brown[700],
        primarySwatch: Colors.brown,
        cardColor: Colors.brown[900],
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),

        /// where is used?
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.white.withOpacity(0.2),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IntroView(),
    );
  }
}
