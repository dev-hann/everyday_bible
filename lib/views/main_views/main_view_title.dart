part of views;

class MainViewTitle extends StatefulWidget {
  @override
  _MainViewTitleState createState() => _MainViewTitleState();
}

class _MainViewTitleState extends State<MainViewTitle> {
  BibleController _bibleController;

  void initState(){
    super.initState();
    _bibleController = Provider.of<BibleController>(context,listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height/5,
      child: Align(
        alignment: Alignment(-0.8,0.3),
        child: Text.rich(
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
        ),
      ),
    );
  }
}
