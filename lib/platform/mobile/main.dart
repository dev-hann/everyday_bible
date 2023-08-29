import 'package:everydaybible/platform/mobile/home_view.dart';
import 'package:flutter/material.dart';

class MoboleApp extends StatelessWidget {
  const MoboleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Everyday Bible",
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
