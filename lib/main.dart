import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/intro_views/intro_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
void main() async{
  await Hive.initFlutter();
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
        /// where is used?
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.white.withOpacity(0.2),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(
             bodyText2: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            headline2: TextStyle(fontWeight: FontWeight.bold)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IntroView(),
    );
  }
}
