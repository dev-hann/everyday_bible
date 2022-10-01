import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/repo/qt_repo/qt_repo.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:everydaybible/views/home_view/home_view.dart';
import 'package:flutter/material.dart';

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  @override
  void initState() {
    super.initState();
    loadRepoList();
  }

  Future loadRepoList() async {
    await Future.wait([
      Repo.of<BibleRepo>(context).init(),
      Repo.of<QTRepo>(context).init(),
    ]).then((value) {
      Navigator.of(context).pushReplacement(HomeView.route());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
