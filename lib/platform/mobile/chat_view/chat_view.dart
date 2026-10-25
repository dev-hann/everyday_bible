import 'dart:async';

import 'package:everydaybible/model/chat/chat_message.dart';
import 'package:everydaybible/platform/mobile/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/platform/mobile/chat_view/bloc/chat_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Main chat view: ask questions and receive scripture-grounded answers.
class ChatView extends StatefulWidget {
  /// Creates the chat view.
  const ChatView({
    super.key,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  static const List<String> _examples = [
    '요한복음 3:16을 풀어줘',
    '오늘 읽던 본문 한 구절 골라서 묵상을 도와줘',
    '시편 23편에서 위로받는 방법을 알려줘',
  ];

  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _lastMessageCount = 0;

  ChatBloc get bloc => BlocProvider.of(context);

  @override
  void initState() {
    super.initState();
    bloc.add(const ChatEventInited());
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final bible = context.read<BibleBloc>().state;
    bloc.add(
      ChatEventSent(
        trimmed,
        bookName: bible.selectedData?.name,
        chapterNumber: bible.selectedChapter?.number,
        verses: bible.selectedChapter?.verseList,
      ),
    );
    _inputController.clear();
  }

  void _openHistory() {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (sheetContext) {
          return SafeArea(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                final sessions = state.sessions;
                if (sessions.isEmpty) {
                  return const ListTile(
                    title: Text('저장된 대화가 없어요'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return ListTile(
                      leading: const Icon(Icons.forum_outlined),
                      title: Text(
                        session.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        DateFormat('yyyy.MM.dd HH:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            session.updatedAt,
                          ),
                        ),
                      ),
                      onTap: () {
                        bloc.add(ChatEventSessionSelected(session.id));
                        Navigator.of(sheetContext).pop();
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        switch (state.status) {
          case ChatViewStatus.init:
            return const BibleLoading();
          case ChatViewStatus.success:
        }
        _scheduleScroll(state);
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('AI 성경 해설'),
            actions: [
              IconButton(
                tooltip: '지난 대화',
                icon: const Icon(Icons.history),
                onPressed: _openHistory,
              ),
              IconButton(
                tooltip: '새 대화',
                icon: const Icon(Icons.add_comment_outlined),
                onPressed: () {
                  bloc.add(const ChatEventNewSessionStarted());
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: state.messages.isEmpty && !state.isStreaming
                    ? _EmptyChat(
                        onExampleTap: (example) =>
                            _inputController.text = example,
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            state.messages.length + (state.isStreaming ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < state.messages.length) {
                            return _MessageBubble(
                              message: state.messages[index],
                            );
                          }
                          return _MessageBubble(
                            message: ChatMessage(
                              id: 'streaming',
                              sessionId: '',
                              role: ChatRole.assistant,
                              content: state.streamingText ?? '',
                              createdAt: 0,
                            ),
                            streaming: true,
                          );
                        },
                      ),
              ),
              _InputBar(
                controller: _inputController,
                enabled: !state.isStreaming,
                onSubmitted: _send,
              ),
            ],
          ),
        );
      },
    );
  }

  void _scheduleScroll(ChatState state) {
    final count = state.messages.length + (state.isStreaming ? 1 : 0);
    if (count == _lastMessageCount) {
      return;
    }
    _lastMessageCount = count;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }
}

/// Bubble rendering a single chat message.
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    this.streaming = false,
  });

  final ChatMessage message;

  final bool streaming;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    final scheme = Theme.of(context).colorScheme;
    final body = streaming ? '${message.content}▌' : message.content;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color:
              isUser ? scheme.primaryContainer : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: SelectableText(
          body,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

/// Empty-state guide shown before the first question.
class _EmptyChat extends StatelessWidget {
  const _EmptyChat({
    required this.onExampleTap,
  });

  final ValueChanged<String> onExampleTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              '무엇이든 물어보세요',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              '구절을 언급하면 본문을 찾아 성경적으로 풀어드려요',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                for (final example in _ChatViewState._examples)
                  ActionChip(
                    label: Text(example),
                    onPressed: () => onExampleTap(example),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Message input bar with a send button.
class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.enabled,
    required this.onSubmitted,
  });

  final TextEditingController controller;

  final bool enabled;

  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: '질문을 입력하세요',
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final canSend = enabled && value.text.trim().isNotEmpty;
                return IconButton.filled(
                  icon: const Icon(Icons.send_outlined),
                  onPressed:
                      canSend ? () => onSubmitted(controller.text) : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
