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

  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Widget gradientBackground({required Widget child}) {
    return ColoredBox(
      color: Colors.white,
      child: Container(
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
      ),
    );
  }

  Widget _bottomPlayer() {
    return BottomAudioPlayer(
      audioAsset: _viewModel.audioAsset,
      title: _viewModel.title,
      subtitle: _viewModel.subtitle,
    );
  }

  Widget _gospelsListView() {
    Widget _listView() {
      return ListView.builder(
        controller: _viewModel.gospelScrollController,
        padding: EdgeInsets.symmetric(vertical: kToolbarHeight, horizontal: 8),
        itemCount: _viewModel.gospels.length,
        itemBuilder: (_, index) {
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
                children: [
                  _sectionLine(gospel.key),
                  _sectionText(gospel.value)
                ],
              ),
            );
          }

          return _gospelBox(_viewModel.gospels.entries.toList()[index]);
        },
      );
    }

    return ShaderMask(
      shaderCallback: (Rect rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.transparent],
          stops: [0, 0.05],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: _listView(),
    );
  }

  Widget _appBar() {
    Widget _title() {
      List<String> _titleList = _viewModel.title.split(" ");
      return Wrap(
        alignment: WrapAlignment.center,
        children: _titleList
            .map(
              (e) => Text(
                e + " ",
                style: Get.textTheme.headline4!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            )
            .toList(),
      );
    }

    Widget _subtitle() {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: _viewModel.subtitle),
            TextSpan(text: "\n"),
            TextSpan(
                text: _viewModel.dateTime,
                style: Get.textTheme.subtitle1!.copyWith(fontSize: 13)),
          ],
          style: Get.textTheme.subtitle1,
        ),
        textAlign: TextAlign.center,
      );
    }

    Widget _preButton() {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios_sharp,
        ),
        onPressed: _viewModel.onTapYesterday,
      );
    }

    Widget _nextButton() {
      Widget _dialogWidget() {
        return GestureDetector(
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
                child: Card(
                    child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "\"EveryDay Bible\"",
                    style:
                        Get.textTheme.headline4!.copyWith(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Get.theme.primaryColor,
                    ),
                  ),
                  Text("아직 말씀이 준비 되지 않았습니다."),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text("확인"),
                  ),
                ],
              ),
            ))),
          ),
        );
      }

      return IconButton(
        icon: Icon(Icons.arrow_forward_ios_sharp),
        onPressed: () {
          if (_viewModel.hasTomorrow) {
            _viewModel.onTapTomorrow();
          } else {
            Get.dialog(_dialogWidget());
          }
        },
      );
    }

    return Column(
      children: [
        Row(
          children: [
            _preButton(),
            Expanded(child: _title()),
            _nextButton(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _subtitle(),
        ),
      ],
    );
  }

  Widget _view() {
    return gradientBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight * 0.8),
                child: _appBar(),
              ),
              Expanded(child: _gospelsListView()),
            ],
          ),
          bottomNavigationBar: _bottomPlayer(),
        ),
      ),
    );
  }

  Widget _loading() {
    if (!_viewModel.isLoading) return SizedBox.shrink();
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AudioServiceWidget(
      child: Stack(
        children: [
          _view(),
          _loading(),
        ],
      ),
    );
  }
}
