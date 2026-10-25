import 'package:equatable/equatable.dart';

/// The author of a chat message.
enum ChatRole {
  /// The user asking a question.
  user,

  /// The AI assistant answering.
  assistant;

  /// Parses a stored role string back into a [ChatRole].
  static ChatRole fromName(String name) {
    return name == 'user' ? ChatRole.user : ChatRole.assistant;
  }

  /// Serializes the role for drift storage.
  String get name => this == ChatRole.user ? 'user' : 'assistant';
}

/// A single message in a chat conversation.
class ChatMessage extends Equatable {
  /// Creates a chat message.
  const ChatMessage({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  /// Unique message identifier (creation timestamp in milliseconds).
  final String id;

  /// Identifier of the session this message belongs to.
  final String sessionId;

  /// Who authored the message.
  final ChatRole role;

  /// Raw message text.
  final String content;

  /// Creation timestamp in milliseconds since the epoch.
  final int createdAt;

  @override
  List<Object?> get props => [
        id,
        sessionId,
        role,
        content,
        createdAt,
      ];
}
