class Bible {
  Bible({this.title, this.audio, this.gospel, this.subTitle});

  final DateTime _dateTime = DateTime.now();
  final Map<int, String> gospel;
  final String audio;
  final String title;
  final String subTitle;

  get dateTime => _dateTime;
}
