
part of qt_lib;

class QTTitleView extends StatelessWidget {
  const QTTitleView();

  Widget _effectiveTitle(String title) {
    List<String> _titleList = title.split(" ");
    return Wrap(
      alignment: WrapAlignment.center,
      children: _titleList
          .map((e) => Text(
                e + " ",
                style: Get.textTheme.headline4!
                    .copyWith(fontWeight: FontWeight.bold),
              ))
          .toList(),
    );
  }

  Widget _subtitle(String _subtitle, String dateTime) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: _subtitle),
          TextSpan(text: "\n"),
          TextSpan(
              text: dateTime,
              style: Get.textTheme.subtitle1!.copyWith(fontSize: 13)),
        ],
        style: Get.textTheme.subtitle1,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _preButton(VoidCallback onTap) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_sharp,
      ),
      onPressed: onTap,
    );
  }

  Widget _nextButton(VoidCallback onTap) {
    return IconButton(
      icon: Icon(Icons.arrow_forward_ios_sharp),
      onPressed: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QTController>(
      builder: (_controller) {
        final QTTitleViewModel _viewModel = QTTitleViewModel(_controller);
        return Column(
          children: [
            Row(
              children: [
                _preButton(_viewModel.onTapPreButton),
                Expanded(child: _effectiveTitle(_viewModel.title)),
                _nextButton(_viewModel.onTapNextButton),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _subtitle(_viewModel.subtitle, _viewModel.dateTime),
            ),
          ],
        );
      },
    );
  }
}
