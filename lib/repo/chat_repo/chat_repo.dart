import 'dart:async';

import 'package:everydaybible/data_base/app_database.dart';
import 'package:everydaybible/model/chat/chat_message.dart';
import 'package:everydaybible/model/chat/chat_session.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:firebase_ai/firebase_ai.dart' hide ChatSession;

part 'chat_impl.dart';

/// Repository streaming AI answers and persisting chat history.
abstract class ChatRepo extends Repo {
  /// Streams the assistant answer for [question], grounded on the
  /// [scriptureContext] text and the earlier [history] messages.
  Stream<String> sendMessage({
    required String question,
    required String scriptureContext,
    List<ChatMessage> history,
  });

  /// Persists a single chat message.
  Future<void> saveMessage(ChatMessage message);

  /// Upserts the session row identified by its id.
  Future<void> upsertSession(ChatSession session);

  /// Returns every session, newest first.
  Future<List<ChatSession>> loadSessions();

  /// Returns the messages of [sessionId], oldest first.
  Future<List<ChatMessage>> loadMessages(String sessionId);

  /// Deletes the session [sessionId] together with its messages.
  Future<void> deleteSession(String sessionId);
}
