import 'package:everydaybible/model/chat/chat_message.dart';
import 'package:everydaybible/model/chat/chat_session.dart';
import 'package:everydaybible/platform/mobile/main.dart' as mobile;

import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/repo/chat_repo/chat_repo.dart';
import 'package:everydaybible/repo/memo_repo/memo_repo.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:everydaybible/repo/setting_repo/repo_setting.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubChatRepo extends ChatRepo {
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

void main() {
  testWidgets('App boots to loading state with stub repos', (tester) async {
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<BibleRepo>(create: (_) => BibleImpl()),
          RepositoryProvider<QuiteTimeRepo>(create: (_) => QuiteTimeImpl()),
          RepositoryProvider<AudioRepo>(create: (_) => AudioImpl()),
          RepositoryProvider<SettingRepo>(create: (_) => SettingImpl()),
          RepositoryProvider<MemoRepo>(create: (_) => MemoImpl()),
          RepositoryProvider<ChatRepo>(create: (_) => _StubChatRepo()),
        ],
        child: const mobile.App(),
      ),
    );

    await tester.pump();

    expect(find.byType(BibleLoading), findsOneWidget);
  });
}
