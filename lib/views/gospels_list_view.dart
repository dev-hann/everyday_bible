part of views;

class GospelListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GospelListViewState();
  }
}

class _GospelListViewState extends State<GospelListView> {
  BibleController _bibleController = BibleController();


  Widget _gospelBox(int index) {
    Widget _sectionLine(int index) {
      return Row(
        children: [
          Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text("$index"),
              )),
          Expanded(
              flex: 9,
              child: Divider(
                color: Colors.white70,
              ))
        ],
      );
    }

    Widget _sectionText(String text) {
      return Text(
        text,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLine(_bibleController.gospels.keys.toList()[index]),
          _sectionText(_bibleController.gospels.values.toList()[index])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _bibleController.gospels.length,
      itemBuilder: (context, index) {
        return _gospelBox(index);
      },
    );

  }
}
