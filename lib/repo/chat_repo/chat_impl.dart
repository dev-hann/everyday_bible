part of 'chat_repo.dart';

/// [ChatRepo] implementation calling Gemini through Firebase AI Logic and
/// storing the conversation in the drift chat tables.
class ChatImpl extends ChatRepo {
  /// Creates the repository with its Gemini model and persona prompt.
  ChatImpl()
      : _model = FirebaseAI.googleAI().generativeModel(
          model: _modelName,
          systemInstruction: Content.system(_systemPrompt),
        );

  /// Maximum number of earlier messages sent along with the question.
  static const int _maxHistoryLength = 20;

  static const String _modelName = 'gemini-3.5-flash-lite';

  static const String _systemPrompt = '''
너는 한국어로 대화하는 성경 교사다. 사용자의 질문에 다음 원칙으로 답하라.
1. "본문" 블록에 제공된 성경 구절(개역한글)을 해설의 근거로 삼고, 인용할 때는 "요한복음 3:16"처럼 장절을 붙여라.
2. 본문에 없는 내용은 일반적인 성경 지식으로 보충하되, 본문과 구분해 설명하라.
3. 성경 번역이나 교단 논쟁에 대해서는 중립적으로 여러 관점을 제시하라.
4. 필요하면 질문자에게 되묻거나 적용 질문을 하나 제안하라.
5. 교만하지 않고 따뜻하되, 설교조의 장문보다는 핵심을 명료하게 전달하라.''';

  final GenerativeModel _model;
  final AppDatabase _db = AppDatabase.instance;

  @override
  Stream<String> sendMessage({
    required String question,
    required String scriptureContext,
    List<ChatMessage> history = const [],
  }) async* {
    final recent = history.length > _maxHistoryLength
        ? history.sublist(history.length - _maxHistoryLength)
        : history;
    final contents = <Content>[
      for (final message in recent)
        if (message.role == ChatRole.user)
          Content.text(message.content)
        else
          Content.model([TextPart(message.content)]),
      Content.text('$scriptureContext\n\n질문: $question'),
    ];
    final response = _model.generateContentStream(contents);
    await for (final chunk in response) {
      final text = chunk.text;
      if (text != null && text.isNotEmpty) {
        yield text;
      }
    }
  }

  @override
  Future<void> saveMessage(ChatMessage message) async {
    await _db.into(_db.chatMessages).insert(
          ChatMessagesCompanion.insert(
            id: message.id,
            sessionId: message.sessionId,
            role: message.role.name,
            content: message.content,
            createdAt: message.createdAt,
          ),
        );
  }

  @override
  Future<void> upsertSession(ChatSession session) async {
    await _db.into(_db.chatSessions).insertOnConflictUpdate(
          ChatSessionsCompanion.insert(
            id: session.id,
            title: session.title,
            createdAt: session.createdAt,
            updatedAt: session.updatedAt,
          ),
        );
  }

  @override
  Future<List<ChatSession>> loadSessions() async {
    final rows = await _db.select(_db.chatSessions).get();
    return rows
        .map(
          (row) => ChatSession(
            id: row.id,
            title: row.title,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
          ),
        )
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<List<ChatMessage>> loadMessages(String sessionId) async {
    final rows = await (_db.select(_db.chatMessages)
          ..where((tbl) => tbl.sessionId.equals(sessionId)))
        .get();
    return rows
        .map(
          (row) => ChatMessage(
            id: row.id,
            sessionId: row.sessionId,
            role: ChatRole.fromName(row.role),
            content: row.content,
            createdAt: row.createdAt,
          ),
        )
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await (_db.delete(_db.chatMessages)
          ..where((tbl) => tbl.sessionId.equals(sessionId)))
        .go();
    await (_db.delete(_db.chatSessions)
          ..where((tbl) => tbl.id.equals(sessionId)))
        .go();
  }
}
