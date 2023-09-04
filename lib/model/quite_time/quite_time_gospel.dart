import 'package:equatable/equatable.dart';

class QuiteTimeGospel extends Equatable {
  const QuiteTimeGospel({
    required this.chapter,
    required this.verse,
    required this.gospel,
  });
  final int chapter;
  final int verse;
  final String gospel;

  @override
  List<Object?> get props => [
        chapter,
        verse,
        gospel,
      ];

  factory QuiteTimeGospel.fromMap(Map<String, dynamic> map) {
    return QuiteTimeGospel(
      chapter: map['Chapter'] as int,
      verse: map['Verse'] as int,
      gospel: map['Bible_Cn'] as String,
    );
  }
}
