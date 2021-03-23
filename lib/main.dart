import 'package:everydaybible/controller/bible_audio_controller.dart';
import 'package:everydaybible/controller/bible_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'views/view_lib.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BibleController(),
        ),
        ChangeNotifierProvider(
          create: (_) => BibleAudioPlayer(),
        )
      ],
      child:GetMaterialApp(
        title: 'EveyDay Bible',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.brown.shade700,
          primarySwatch: Colors.brown,
          cardColor: Colors.brown.shade900,
          iconTheme: IconThemeData(color: Colors.white),
          bottomNavigationBarTheme:
              BottomNavigationBarThemeData(backgroundColor: Colors.transparent),
          textTheme: TextTheme(
              bodyText2: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Splash(),
      ),
    );
  }
}
