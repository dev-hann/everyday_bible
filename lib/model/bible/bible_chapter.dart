import 'package:equatable/equatable.dart';

class BibleChapter extends Equatable {
  const BibleChapter({
    required this.number,
    required this.verseList,
  });
  final int number;
  final List<String> verseList;

  @override
  List<Object?> get props => [
        number,
        verseList,
      ];
}
