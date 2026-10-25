part of 'chat_bloc.dart';

/// Lifecycle status of the chat view.
enum ChatViewStatus {
  /// The view has not been initialized yet.
  init,

  /// History and repositories are ready.
  success,
}

/// State of the chat view: sessions, the open conversation, and streaming
/// progress of the answer being generated.
class ChatState extends Equatable {
  /// Creates the chat state.
  const ChatState({
    this.status = ChatViewStatus.init,
    this.sessions = const [],
    this.currentSession,
    this.messages = const [],
    this.isStreaming = false,
    this.streamingText,
  });

  /// Lifecycle status of the view.
  final ChatViewStatus status;

  /// Every stored session, newest first.
  final List<ChatSession> sessions;

  /// The session currently open, `null` before the first question.
  final ChatSession? currentSession;

  /// Messages of the open conversation, oldest first.
  final List<ChatMessage> messages;

  /// Whether an answer is currently being streamed.
  final bool isStreaming;

  /// Partial text of the answer being streamed, `null` when idle.
  final String? streamingText;

  @override
  List<Object?> get props => [
        status,
        sessions,
        currentSession,
        messages,
        isStreaming,
        streamingText,
      ];

  /// Returns a copy of this state with the given fields replaced.
  ChatState copyWith({
    ChatViewStatus? status,
    List<ChatSession>? sessions,
    ChatSession? currentSession,
    List<ChatMessage>? messages,
    bool? isStreaming,
    String? streamingText,
    bool clearSession = false,
    bool clearStreamingText = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      currentSession:
          clearSession ? null : currentSession ?? this.currentSession,
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
      streamingText:
          clearStreamingText ? null : streamingText ?? this.streamingText,
    );
  }
}
