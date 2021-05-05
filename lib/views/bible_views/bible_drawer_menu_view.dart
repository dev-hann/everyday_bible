
part of bible_lib;

class BibleDrawerMenuView extends StatefulWidget {
  @override
  _BibleDrawerMenuViewState createState() => _BibleDrawerMenuViewState();
}

class _BibleDrawerMenuViewState extends State<BibleDrawerMenuView> {
  late BibleDrawerMenuViewModel _viewModel;

  void initState() {
    super.initState();
    final BibleController _controller = Get.find();
    _viewModel = BibleDrawerMenuViewModel(controller: _controller)
      ..addListener(_listener);
    _viewModel.init();
  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _titleWidget() {
    return Text(
      "Bible",
      style: Get.textTheme.headline2,
    );
  }

  Widget _bibleListView() {
    return ListView.builder(
      controller: _viewModel.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 5),
      itemCount: _viewModel.bibleListLength,
      itemBuilder: (_, index) {
        return AutoScrollTag(
          controller: _viewModel.scrollController,
          key: ValueKey(index),
          index: index,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: _DrawerMenuItem(
              title: _viewModel.bibleList[index].title,
              maxChapter: _viewModel.bibleList[index].chapterListLength,
              expanded: _viewModel.expandedList[index],
              onTapTitle: () {
                _viewModel.onTapMenuItem(index);
              },
              onTapChapter: (chapterIndex) {
                _viewModel.onTapChapter(index,chapterIndex);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _homeWidget() {
    return TextButton.icon(
      onPressed: Get.back,
      icon: FaIcon(
        FontAwesomeIcons.pagelines,
        color: Colors.white,
      ),
      label: Text(
        "Home",
        style: Get.textTheme.headline6!.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _body({required Widget child}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: Get.width / 1.7,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: kToolbarHeight * 1.5,
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ZoomDrawer.of(context)!.toggle();
      },
      child: BibleScaffold(
        body: _body(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleWidget(),
              Divider(
                height: 1,
                thickness: 1,
                color: Get.theme.primaryColor,
              ),
              Expanded(child: _bibleListView()),
              _homeWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerMenuItem extends StatefulWidget {
  _DrawerMenuItem({
    required this.title,
    required this.maxChapter,
    required this.expanded,
    required this.onTapTitle,
    required this.onTapChapter,
  });

  final String title;
  final int maxChapter;
  final bool expanded;
  final VoidCallback onTapTitle;
  final Function(int index) onTapChapter;

  @override
  State<StatefulWidget> createState() {
    return __DrawerMenuItemState();
  }
}

class __DrawerMenuItemState extends State<_DrawerMenuItem> {
  Widget titleWidget() {
    IconData _iconData =
        widget.expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down;
    return GestureDetector(
      onTap: widget.onTapTitle,
      child: ColoredBox(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 22),
            ),
            Icon(_iconData),
          ],
        ),
      ),
    );
  }

  Widget chapterWidget() {
    if (!widget.expanded) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int index = 0; index < widget.maxChapter; index++) ...[
          Divider(),
          GestureDetector(
            onTap: () {
              widget.onTapChapter(index);
            },
            child: ColoredBox(
              color: Colors.transparent,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      "${index+1}장",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      shadowStrength: 2,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget(),
            chapterWidget(),
          ],
        ),
      ),
    );
  }
}
