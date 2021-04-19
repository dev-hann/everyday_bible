part of views;

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() {
    return _LoadingViewState();
  }
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
 late LoadingViewModel _viewModel;

  void initState() {
    super.initState();
    final bible = Provider.of<BibleDatabase>(context,listen: false);
    _viewModel = LoadingViewModel(bible, vsync: this)
      ..addListener(() {
        if(mounted) {
          setState(() {});
        }
      });
  }

  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  Widget _title() {
    Widget _titleText() {
      return Opacity(
        opacity: _viewModel.titleAnimationValue,
        child: Text(
          "Everyday",
          style: Get.textTheme.headline2,
        ),
      );
    }

    Widget _subTitleText() {
      return Opacity(
        opacity: _viewModel.subtitleAnimationValue,
        child: Text(
          "Bible",
          style: Get.textTheme.headline2!.copyWith(
              color: Get.theme.primaryColorDark),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleText(),
        _subTitleText(),
      ],
    );
  }

  Widget _button() {
    Widget _loadingWidget() {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(),
      );
    }

    Widget _nextButton() {
      return GestureDetector(
          onTap: () async {
            Get.offAll(()=>EveryDayBible(),
                transition: Transition.fadeIn,
                duration: Duration(seconds: 1));
          },
          child: Text("Amen"));
    }

    Widget _child =
        _viewModel.loadingCompleted ? _nextButton() : _loadingWidget();
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 1500),
      child: _child,
    );
  }

  Widget _copyRight() {
    return Text(
      "Copyright © 2018 Scripture Union Korea. All rights reserved.",
      style: Get.textTheme.bodyText1!
          .copyWith(color: Colors.brown.shade300, fontSize: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
            Get.theme.primaryColorLight.withOpacity(0.7),
            Get.theme.primaryColorDark,
          ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
        ),
        child: Stack(
          children: [
            Align(alignment: Alignment(-0.7, -0.5), child: _title()),
            Align(alignment: Alignment(0.8, 0.7), child: _button()),
            Align(alignment: Alignment(0, 0.9), child: _copyRight()),
          ],
        ),
      ),
    );
  }
}
