
part of intro_lib;

class IntroTitleView extends StatefulWidget {
  @override
  _IntroTitleViewState createState() => _IntroTitleViewState();
}

class _IntroTitleViewState extends State<IntroTitleView>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _subtitleController;

  void initState() {
    super.initState();
    _loadAnimation();
  }

  void _loadAnimation() async {
    _titleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(_listener);
    _subtitleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(_listener);

    await _titleController.forward();
    _subtitleController.forward();
  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _titleWidget() {
    return Opacity(
      opacity: _titleController.value,
      child: Text(
        "Everyday",
        style: Get.textTheme.headline2,
      ),
    );
  }

  Widget _subtitleWidget() {
    return Opacity(
      opacity: _subtitleController.value,
      child: Text(
        "Bible",
        style: Get.textTheme.headline2!
            .copyWith(color: Get.theme.primaryColorDark),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleWidget(),
        _subtitleWidget(),
      ],
    );
  }
}
