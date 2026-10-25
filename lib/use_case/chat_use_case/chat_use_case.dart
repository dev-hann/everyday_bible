import 'package:everydaybible/model/chat/chat_message.dart';
import 'package:everydaybible/model/chat/chat_session.dart';
import 'package:everydaybible/model/failure.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/repo/chat_repo/chat_repo.dart';
import 'package:everydaybible/use_case/bible_use_case/bible_use_case.dart';
import 'package:everydaybible/use_case/use_case.dart';
import 'package:fpdart/fpdart.dart';

/// Use case orchestrating scripture lookup and AI chat persistence.
class ChatUseCase extends UseCase<ChatRepo> {
  /// Creates the chat use case backed by [repo] and the Bible repository.
  ChatUseCase(super.repo, BibleRepo bibleRepo)
      : bible = BibleUseCase(bibleRepo);

  /// Maximum length of a session display title.
  static const int _titleLength = 24;

  /// Bible use case used for scripture lookups.
  final BibleUseCase bible;

  List<MapEntry<String, List<List<String>>>> _chapterCache = [];

  /// Loads the bundled Bible data so references can be resolved.
  Future<void> initBibleDataBase() async {
    await bible.initDataBase();
    bible.loadBibleDataList().fold(
      (fail) {},
      (list) {
        _chapterCache = [
          for (final data in list)
            MapEntry(
              data.name,
              [
                for (final chapter in data.chapterList) chapter.verseList,
              ],
            ),
        ];
      },
    );
  }

  /// Builds the scripture context block injected into the AI prompt.
  ///
  /// Resolves references in [question] (e.g. "요한복음 3:16", "시편 23"),
  /// falling back to the chapter the reader is currently showing.
  String buildScriptureContext(
    String question, {
    String? currentBookName,
    int? currentChapterNumber,
    List<String>? currentVerses,
  }) {
    final referenced = _resolveReference(question);
    if (referenced != null) {
      return _formatVerses(
        referenced.key,
        referenced.value.$1,
        referenced.value.$2,
      );
    }
    final chapterOnly = RegExp(r'(\d+)\s*장').firstMatch(question);
    if (chapterOnly != null &&
        currentBookName != null &&
        currentVerses != null) {
      final chapter = int.parse(chapterOnly.group(1)!);
      final verses = _chapterVerses(currentBookName, chapter);
      if (verses != null) {
        return _formatVerses(currentBookName, chapter, verses);
      }
      if (chapter == currentChapterNumber) {
        return _formatVerses(currentBookName, chapter, currentVerses);
      }
    }
    if (currentBookName != null && currentVerses != null) {
      return _formatVerses(
        currentBookName,
        currentChapterNumber ?? 0,
        currentVerses,
      );
    }
    return '본문: (질문에 특정 구절이 없고 현재 읽던 본문도 없습니다. '
        '일반적인 성경 지식으로 답하고, 인용이 필요하면 개역한글 표기를 따르세요.)';
  }

  /// Streams the assistant answer chunks for [question].
  Stream<String> ask({
    required String question,
    required String scriptureContext,
    List<ChatMessage> history = const [],
  }) {
    return repo.sendMessage(
      question: question,
      scriptureContext: scriptureContext,
      history: history,
    );
  }

  /// Persists a message row.
  Future<void> saveMessage(ChatMessage message) => repo.saveMessage(message);

  /// Upserts a session row.
  Future<void> upsertSession(ChatSession session) =>
      repo.upsertSession(session);

  /// Loads all sessions, newest first; [Left] on a database failure.
  Future<Either<Failure, List<ChatSession>>> loadSessions() async {
    try {
      return Right(await repo.loadSessions());
    } on Object catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  /// Loads the messages of [sessionId]; [Left] on a database failure.
  Future<Either<Failure, List<ChatMessage>>> loadMessages(
    String sessionId,
  ) async {
    try {
      return Right(await repo.loadMessages(sessionId));
    } on Object catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  /// Deletes a session and its messages.
  Future<void> deleteSession(String sessionId) => repo.deleteSession(sessionId);

  /// Truncates the first user message into a session title.
  String titleOf(String question) {
    final trimmed = question.trim().replaceAll(RegExp(r'\s+'), ' ');
    return trimmed.length <= _titleLength
        ? trimmed
        : '${trimmed.substring(0, _titleLength)}…';
  }

  /// Resolves `책 장[:절[-절]]` references in [question] to verse text.
  MapEntry<String, (int, List<String>)>? _resolveReference(String question) {
    for (final entry in _chapterCache) {
      final book = entry.key;
      final match = RegExp(
        '${RegExp.escape(book)}'
        r'\s*(\d+)(?:\s*(?::|장)\s*(\d+))?'
        r'(?:\s*-\s*(\d+))?',
      ).firstMatch(question);
      if (match == null) {
        continue;
      }
      final chapter = int.parse(match.group(1)!);
      final verses = _chapterVerses(book, chapter);
      if (verses == null) {
        continue;
      }
      final verseNumber =
          match.group(2) == null ? null : int.parse(match.group(2)!);
      if (verseNumber == null) {
        return MapEntry(book, (chapter, verses));
      }
      if (verseNumber < 1 || verseNumber > verses.length) {
        return MapEntry(book, (chapter, verses));
      }
      var end = verseNumber;
      final rangeEnd = match.group(3);
      if (rangeEnd != null) {
        end = int.tryParse(rangeEnd) ?? verseNumber;
      }
      if (end > verses.length) {
        end = verses.length;
      }
      if (end < verseNumber) {
        end = verseNumber;
      }
      return MapEntry(
        book,
        (chapter, verses.sublist(verseNumber - 1, end)),
      );
    }
    return null;
  }

  List<String>? _chapterVerses(String book, int chapter) {
    for (final entry in _chapterCache) {
      if (entry.key != book || chapter < 1 || chapter > entry.value.length) {
        continue;
      }
      return entry.value[chapter - 1];
    }
    return null;
  }

  String _formatVerses(String book, int chapter, List<String> verses) {
    final buffer = StringBuffer('본문: $book $chapter장 (개역한글)\n');
    for (var index = 0; index < verses.length; index++) {
      buffer.writeln('${index + 1} ${verses[index].trim()}');
    }
    return buffer.toString().trimRight();
  }
}
