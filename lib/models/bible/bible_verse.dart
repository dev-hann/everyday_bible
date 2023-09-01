import 'package:equatable/equatable.dart';

class BibleVerse extends Equatable {
  const BibleVerse({
    required this.index,
    required this.text,
  });
  final int index;
  final String text;

  @override
  List<Object?> get props => [
        index,
        text,
      ];
}
