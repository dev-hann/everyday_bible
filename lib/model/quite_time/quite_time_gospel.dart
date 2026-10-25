import 'package:equatable/equatable.dart';

/// A single gospel (Bible) verse of the day's QT passage.
class QuiteTimeGospel extends Equatable {
  /// Creates a gospel verse.
  const QuiteTimeGospel({
    required this.chapter,
    required this.verse,
    required this.gospel,
  });

  /// Builds a verse from a QT API JSON payload.
  factory QuiteTimeGospel.fromMap(Map<String, dynamic> map) {
    return QuiteTimeGospel(
      chapter: map['Chapter'] as int,
      verse: map['Verse'] as int,
      gospel: map['Bible_Cn'] as String,
    );
  }

  /// Chapter number the verse belongs to.
  final int chapter;

  /// Verse number within the chapter.
  final int verse;

  /// Text of the verse.
  final String gospel;

  @override
  List<Object?> get props => [
        chapter,
        verse,
        gospel,
      ];
}
