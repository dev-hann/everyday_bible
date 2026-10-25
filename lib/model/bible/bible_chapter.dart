import 'package:equatable/equatable.dart';

/// A single chapter of a Bible book, holding its verses in order.
class BibleChapter extends Equatable {
  /// Creates a chapter with its [number] and [verseList].
  const BibleChapter({
    required this.number,
    required this.verseList,
  });

  /// 1-based chapter number within the book.
  final int number;

  /// Verses of the chapter, ordered by verse number.
  final List<String> verseList;

  @override
  List<Object?> get props => [
        number,
        verseList,
      ];
}
