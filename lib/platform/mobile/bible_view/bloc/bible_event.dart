part of 'bible_bloc.dart';

/// Base class for Bible reader events.
abstract class BibleEvent extends Equatable {
  /// Creates a base Bible reader event.
  const BibleEvent();

  @override
  List<Object> get props => [];
}

/// Initializes the Bible database and loads the list of books.
class BibleEventInited extends BibleEvent {
  /// Creates an init event.
  const BibleEventInited();
}

/// Selects the chapter of a book to show in the reader.
class BibleEventUpdatedChapter extends BibleEvent {
  /// Creates an event selecting [chapter] of [data].
  const BibleEventUpdatedChapter(this.data, this.chapter);

  /// The selected book.
  final BibleData data;

  /// The selected chapter.
  final BibleChapter chapter;

  @override
  List<Object> get props => [data, chapter];
}

/// Requests opening the book/chapter drawer.
class BibleEventOpenedDrawer extends BibleEvent {}
