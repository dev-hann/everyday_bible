import 'package:everydaybible/model/chat/chat_message.dart';
import 'package:everydaybible/model/chat/chat_session.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/repo/chat_repo/chat_repo.dart';
import 'package:everydaybible/use_case/chat_use_case/chat_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBibleRepo extends BibleRepo {
  _FakeBibleRepo(this.data);

  final Map<String, dynamic> data;

  @override
  bool databaseIsEmpty() => false;

  @override
  Future<void> initDataBase() async {}

  @override
  List<MapEntry<String, dynamic>> loadBibleDataList() => data.entries.toList();
}

class _FakeChatRepo extends ChatRepo {
  @override
  Future<void> deleteSession(String sessionId) async {}

  @override
  Future<List<ChatMessage>> loadMessages(String sessionId) async => [];

  @override
  Future<List<ChatSession>> loadSessions() async => [];

  @override
  Stream<String> sendMessage({
    required String question,
    required String scriptureContext,
    List<ChatMessage> history = const [],
  }) async* {}

  @override
  Future<void> saveMessage(ChatMessage message) async {}

  @override
  Future<void> upsertSession(ChatSession session) async {}
}

Map<String, dynamic> _bibleData() {
  return <String, dynamic>{
    'JHN': {
      'name': '요한복음',
      'chapterList': [
        {
          'verseList': ['첫째 장 첫 절', '첫째 장 둘째 절'],
        },
        {
          'verseList': [
            '둘째 장 첫 절',
            '둘째 장 둘째 절',
          ],
        },
        {
          'verseList': [
            '셋째 장 첫 절',
            '하나님이 세상을 이처럼 사랑하사',
            '셋째 장 셋째 절',
          ],
        },
      ],
    },
  };
}

void main() {
  late ChatUseCase useCase;

  setUp(() async {
    useCase = ChatUseCase(_FakeChatRepo(), _FakeBibleRepo(_bibleData()));
    await useCase.initBibleDataBase();
  });

  group('buildScriptureContext', () {
    test('resolves book chapter and verse reference', () {
      final context = useCase.buildScriptureContext('요한복음 3:2을 풀어줘');
      expect(context, contains('본문: 요한복음 3장'));
      expect(context, contains('하나님이 세상을 이처럼 사랑하사'));
      expect(context, isNot(contains('셋째 장 첫 절')));
    });

    test('falls back to whole chapter for out-of-range verse', () {
      final context = useCase.buildScriptureContext('요한복음 3:16을 풀어줘');
      expect(context, contains('셋째 장 첫 절'));
      expect(context, contains('셋째 장 셋째 절'));
    });

    test('resolves whole chapter when only chapter given', () {
      final context = useCase.buildScriptureContext('요한복음 2장 요약해줘');
      expect(context, contains('둘째 장 첫 절'));
      expect(context, contains('둘째 장 둘째 절'));
    });

    test('falls back to the chapter number with the current book', () {
      final context = useCase.buildScriptureContext(
        '3장이 무슨 뜻이야?',
        currentBookName: '요한복음',
        currentChapterNumber: 3,
        currentVerses: const ['셋째 장 첫 절'],
      );
      expect(context, contains('본문: 요한복음 3장'));
      expect(context, contains('셋째 장 첫 절'));
    });

    test('falls back to the currently open chapter', () {
      final context = useCase.buildScriptureContext(
        '이 본문을 묵상하고 싶어',
        currentBookName: '요한복음',
        currentChapterNumber: 1,
        currentVerses: const ['첫째 장 첫 절'],
      );
      expect(context, contains('본문: 요한복음 1장'));
      expect(context, contains('첫째 장 첫 절'));
    });

    test('returns fallback note without any scripture', () {
      final context = useCase.buildScriptureContext('기도는 어떻게 해야 해?');
      expect(context, contains('일반적인 성경 지식'));
    });
  });

  group('titleOf', () {
    test('trims and collapses whitespace', () {
      expect(useCase.titleOf('  안녕   하세요  '), '안녕 하세요');
    });

    test('truncates long questions with an ellipsis', () {
      final title = useCase.titleOf('아' * 30);
      expect(title.length, 25);
      expect(title.endsWith('…'), isTrue);
    });
  });
}
