import 'package:everydaybible/bible/bible.dart';
import 'package:everydaybible/utils/bible_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// import 'package:firebase_core/firebase_core.dart'
import 'views/view_lib.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => BibleDatabase(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Everyday Bible',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.brown[700],
          primarySwatch: Colors.brown,
          cardColor: Colors.brown[900],
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(
              bodyText2: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              headline2: TextStyle(fontWeight: FontWeight.bold)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BibleTest(),
      ),
    );
  }
}
