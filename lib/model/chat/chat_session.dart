import 'package:equatable/equatable.dart';

/// A chat conversation grouping its messages.
class ChatSession extends Equatable {
  /// Creates a chat session.
  const ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Unique session identifier (creation timestamp in milliseconds).
  final String id;

  /// Short display title derived from the first user message.
  final String title;

  /// Creation timestamp in milliseconds since the epoch.
  final int createdAt;

  /// Last activity timestamp in milliseconds since the epoch.
  final int updatedAt;

  /// Returns a copy of this session with the given fields replaced.
  ChatSession copyWith({
    String? title,
    int? updatedAt,
  }) {
    return ChatSession(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        createdAt,
        updatedAt,
      ];
}
