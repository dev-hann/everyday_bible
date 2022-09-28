import 'package:everydaybible/data_base/data/box.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/views/intro_view/intro_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await LocalBox.init();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BibleRepo>(create: (_) => BibleImpl()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Everyday Bible",
      home: IntroView(),
    );
  }
}
