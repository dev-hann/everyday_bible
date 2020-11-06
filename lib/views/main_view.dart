part of views;

class EveryDayBible extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EveryDayBibleState();
  }
}

class _EveryDayBibleState extends State<EveryDayBible>
    with TickerProviderStateMixin {
  BibleController _bibleController=BibleController();

  Widget _title() {

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: _bibleController.title + "\n"),
          TextSpan(
              text: _bibleController.subTitle,
              style: Theme.of(context).textTheme.subtitle2),
        ],
      ),
      style: Theme.of(context)
          .textTheme
          .headline4
          .copyWith(fontWeight: FontWeight.bold),
    );
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
            SizedBox(
              height: ScreenUtil().screenHeight / 5,
              child: Align(
                alignment: Alignment(-0.8, 0.3),
                child: _title(),
              ),
            ),
            Expanded(child: GospelListView()),
            BottomPlayer(
              url: _bibleController.audio,
            )
          ],
        ),
      ),
    );
  }
}
