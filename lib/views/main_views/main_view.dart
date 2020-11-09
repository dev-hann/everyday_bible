part of views;

class EveryDayBible extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EveryDayBibleState();
  }
}

class _EveryDayBibleState extends State<EveryDayBible>
    with TickerProviderStateMixin {
  BibleController _bibleController;

  void initState(){
    super.initState();
    _bibleController = Provider.of<BibleController>(context,listen: false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
            Theme.of(context).primaryColorLight.withOpacity(0.6),
            Theme.of(context).primaryColorDark.withOpacity(0.5),
            Theme.of(context).primaryColorDark,
          ], stops: [
            0.1,
            0.35,
            0.9
          ], begin: Alignment.topRight, end: Alignment.bottomCenter),
        ),
        child: Column(
          children: [
            MainViewTitle(),
            MainViewBodyList(),
            MainViewBottomPlayer(),
          ],
        ),
      ),
    );
  }
}
