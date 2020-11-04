import 'package:everydaybible/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => BibleController(),
      child: MaterialApp(
        title: 'EveyDay Bible',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.brown.shade800,
          primarySwatch: Colors.brown,
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.white70,fontSize: 18)
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Splash(),
      ),
    );
  }
}
