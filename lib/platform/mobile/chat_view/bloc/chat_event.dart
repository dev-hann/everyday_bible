part of 'chat_bloc.dart';

/// Event requesting the initial chat state: Bible data and last session.
class ChatEventInited extends ChatEvent {
  /// Creates the init event.
  const ChatEventInited();
}

/// Event sending a user question to the AI assistant.
class ChatEventSent extends ChatEvent {
  /// Creates the event with the [text] typed by the user and the scripture
  /// the reader is currently showing, used as fallback context.
  const ChatEventSent(
    this.text, {
    this.bookName,
    this.chapterNumber,
    this.verses,
  });

  /// The question text typed by the user.
  final String text;

  /// Name of the book currently open in the reader, if any.
  final String? bookName;

  /// Number of the chapter currently open in the reader, if any.
  final int? chapterNumber;

  /// Verses of the chapter currently open in the reader, if any.
  final List<String>? verses;

  @override
  List<Object?> get props => [
        text,
        bookName,
        chapterNumber,
        verses,
      ];
}

/// Event starting a fresh, empty conversation.
class ChatEventNewSessionStarted extends ChatEvent {
  /// Creates the new-session event.
  const ChatEventNewSessionStarted();
}

/// Event switching the open conversation to the session [id].
class ChatEventSessionSelected extends ChatEvent {
  /// Creates the event for the session [id].
  const ChatEventSessionSelected(this.id);

  /// Identifier of the session to open.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Base class of chat events.
abstract class ChatEvent extends Equatable {
  /// Creates the base event.
  const ChatEvent();

  @override
  List<Object?> get props => [];
}
