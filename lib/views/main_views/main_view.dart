part of views;

class EveryDayBible extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EveryDayBibleState();
  }
}

class _EveryDayBibleState extends State<EveryDayBible>
    with TickerProviderStateMixin {
  late MainViewModel _viewModel;

  void initState() {
    super.initState();
    final bible = Provider.of<BibleDatabase>(context, listen: false);
    _viewModel = MainViewModel(bible)
      ..addListener(() {
        setState(() {});
      });
  }

    Widget titleText() {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: _viewModel.title),
            TextSpan(text: "\n"),
            TextSpan(text: _viewModel.subtitle, style: Get.textTheme.subtitle2),
          ],
        ),
        style: Get.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      );
    }



  AppBar _appBar() {
    return AppBar(
      elevation: 5.0,
      title: Text(_viewModel.title),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_forward_ios_sharp),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _body() {
    Widget _gospelBox(MapEntry<String, String> gospel) {
      Widget _sectionLine(String index) {
        return Row(
          children: [
            Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(index),
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
        return Text(text);
      }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_sectionLine(gospel.key), _sectionText(gospel.value)],
        ),
      );
    }

    final gospels = _viewModel.gospels;
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.transparent],
            stops: [0, 0.05]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: gospels!.length,
        itemBuilder: (context, index) {
          return _gospelBox(gospels.entries.toList()[index]);
        },
      ),
    );
  }

  Widget _gradientBackground({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: <Color>[
          Get.theme.primaryColorLight.withOpacity(0.6),
          Get.theme.primaryColorDark.withOpacity(0.5),
          Get.theme.primaryColorDark,
        ],
        stops: [0.1, 0.35, 0.9],
        begin: Alignment.topRight,
        end: Alignment.bottomCenter,
      )),
      child: child,
    );
  }

  Widget _bottomPlayer() {
    return BottomAudioPlayer(
      audioAsset: _viewModel.audioAsset!,
      title: _viewModel.title!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _gradientBackground(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            // SizedBox(
            //   height: kToolbarHeight,
            // ),
            Expanded(child: _body())
          ],
        ),
      )),
      //     bottomSheet: MainViewBottomPlayer(),
      bottomNavigationBar: _bottomPlayer(),
    );
  }
}
