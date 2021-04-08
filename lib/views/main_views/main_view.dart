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

  Widget _sliverAppBar() {
    Widget _appBar() {
      return AppBar(
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

    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: _CustomPersistentHeaderDelegate(
        background: Get.theme.primaryColor,
        minExtent: kToolbarHeight+24 ,
        maxExtent: kToolbarHeight * 2,
        appBar: _appBar(),
        bottom: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _viewModel.subtitle,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget gradientBackground({required Widget child}) {
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
      audioAsset: _viewModel.audioAsset,
      title: _viewModel.title,
    );
  }

  Widget _gospelsListView() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (_, index) {
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

        return _gospelBox(_viewModel.gospels.entries.toList()[index]);
      },
      childCount: _viewModel.gospels.length,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: gradientBackground(
        child: CustomScrollView(
          slivers: [
            _sliverAppBar(),
            _gospelsListView(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomPlayer(),
    );
  }
}

class _CustomPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _CustomPersistentHeaderDelegate({
    required this.appBar,
    required this.bottom,
    required this.maxExtent,
    required this.minExtent,
    required this.background,
  });

  final double maxExtent;
  final double minExtent;
  final Color background;
  final Widget appBar;
  final Widget bottom;

  double get _bottomHeight => maxExtent - minExtent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double _animatedOpacity = (_bottomHeight - shrinkOffset) / _bottomHeight;

    return Stack(
      children: [
        appBar,
        Align(
          alignment: Alignment.bottomCenter,
          child: Opacity(
            opacity: (_animatedOpacity < 0) ? 0 : _animatedOpacity,
            child: SingleChildScrollView(child: bottom),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
