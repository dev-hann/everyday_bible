import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/model/chat/chat_message.dart';
import 'package:everydaybible/model/chat/chat_session.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/repo/chat_repo/chat_repo.dart';
import 'package:everydaybible/use_case/chat_use_case/chat_use_case.dart';

part 'chat_event.dart';
part 'chat_state.dart';

/// Streams AI answers for the open session and keeps the chat history.
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  /// Creates the bloc backed by the chat and Bible repositories.
  ChatBloc(ChatRepo repo, BibleRepo bibleRepo)
      : useCase = ChatUseCase(repo, bibleRepo),
        super(const ChatState()) {
    on<ChatEventInited>(_onInited);
    on<ChatEventSent>(_onSent);
    on<ChatEventNewSessionStarted>(_onNewSessionStarted);
    on<ChatEventSessionSelected>(_onSessionSelected);
  }

  /// Use case orchestrating scripture lookup and AI chat.
  final ChatUseCase useCase;

  FutureOr<void> _onInited(
    ChatEventInited event,
    Emitter<ChatState> emit,
  ) async {
    await useCase.initBibleDataBase();
    final sessions = await useCase.loadSessions().then(
          (result) => result.fold((_) => <ChatSession>[], (list) => list),
        );
    if (sessions.isEmpty) {
      emit(state.copyWith(status: ChatViewStatus.success));
      return;
    }
    final latest = sessions.first;
    final messages = await useCase.loadMessages(latest.id).then(
          (result) => result.fold((_) => <ChatMessage>[], (list) => list),
        );
    emit(
      state.copyWith(
        status: ChatViewStatus.success,
        sessions: sessions,
        currentSession: latest,
        messages: messages,
      ),
    );
  }

  FutureOr<void> _onSent(
    ChatEventSent event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isStreaming) {
      return;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final session = state.currentSession ??
        ChatSession(
          id: '$now',
          title: useCase.titleOf(event.text),
          createdAt: now,
          updatedAt: now,
        );
    final userMessage = ChatMessage(
      id: '${now}u',
      sessionId: session.id,
      role: ChatRole.user,
      content: event.text,
      createdAt: now,
    );
    await useCase.upsertSession(
      session.copyWith(updatedAt: now),
    );
    unawaited(useCase.saveMessage(userMessage));
    final history = state.messages;
    emit(
      state.copyWith(
        currentSession: session,
        messages: [...history, userMessage],
        isStreaming: true,
        streamingText: '',
      ),
    );

    final scriptureContext = useCase.buildScriptureContext(
      event.text,
      currentBookName: event.bookName,
      currentChapterNumber: event.chapterNumber,
      currentVerses: event.verses,
    );
    final buffer = StringBuffer();
    var failed = false;
    try {
      final answer = useCase.ask(
        question: event.text,
        scriptureContext: scriptureContext,
        history: history,
      );
      await for (final chunk in answer) {
        buffer.write(chunk);
        emit(
          state.copyWith(
            streamingText: buffer.toString(),
          ),
        );
      }
    } on Object catch (e) {
      failed = true;
      emit(
        state.copyWith(
          streamingText: '답변을 가져오지 못했어요.\n$e',
        ),
      );
    }
    final answerText = buffer.toString();
    if (answerText.isNotEmpty) {
      final finishedAt = DateTime.now().millisecondsSinceEpoch;
      final assistantMessage = ChatMessage(
        id: '${finishedAt}a',
        sessionId: session.id,
        role: ChatRole.assistant,
        content: answerText,
        createdAt: finishedAt,
      );
      unawaited(useCase.saveMessage(assistantMessage));
      emit(
        state.copyWith(
          messages: [...state.messages, assistantMessage],
        ),
      );
    } else if (failed) {
      emit(
        state.copyWith(
          messages: [
            ...state.messages,
            ChatMessage(
              id: '${DateTime.now().millisecondsSinceEpoch}e',
              sessionId: session.id,
              role: ChatRole.assistant,
              content: state.streamingText ?? '답변을 가져오지 못했어요.',
              createdAt: DateTime.now().millisecondsSinceEpoch,
            ),
          ],
        ),
      );
    }
    emit(
      state.copyWith(
        isStreaming: false,
        clearStreamingText: true,
        sessions: _upsertSessionList(
          state.sessions,
          session.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch),
        ),
      ),
    );
  }

  void _onNewSessionStarted(
    ChatEventNewSessionStarted event,
    Emitter<ChatState> emit,
  ) {
    if (state.isStreaming) {
      return;
    }
    emit(
      state.copyWith(
        clearSession: true,
        messages: [],
      ),
    );
  }

  FutureOr<void> _onSessionSelected(
    ChatEventSessionSelected event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isStreaming) {
      return;
    }
    final session = state.sessions.where((s) => s.id == event.id).firstOrNull;
    if (session == null) {
      return;
    }
    final messages = await useCase.loadMessages(session.id).then(
          (result) => result.fold((_) => <ChatMessage>[], (list) => list),
        );
    emit(
      state.copyWith(
        currentSession: session,
        messages: messages,
      ),
    );
  }

  List<ChatSession> _upsertSessionList(
    List<ChatSession> sessions,
    ChatSession session,
  ) {
    return [
      session,
      ...sessions.where((s) => s.id != session.id),
    ];
  }
}
