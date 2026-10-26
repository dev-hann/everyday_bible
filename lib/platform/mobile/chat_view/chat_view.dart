import 'dart:async';

import 'package:everydaybible/model/chat/chat_message.dart';
import 'package:everydaybible/platform/mobile/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/platform/mobile/chat_view/bloc/chat_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
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
  // Line breaks keep each chip inside FButton's non-wrapping content row
  // on a 360dp screen.
  static const List<String> _examples = [
    '요한복음 3:16을 풀어줘',
    '오늘 읽던 본문 한 구절 골라서\n묵상을 도와줘',
    '시편 23편에서\n위로받는 방법을 알려줘',
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
      showFSheet<void>(
        context: context,
        side: FLayout.btt,
        builder: (sheetContext) {
          return SafeArea(
            child: BlocProvider<ChatBloc>.value(
              value: bloc,
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  final sessions = state.sessions;
                  if (sessions.isEmpty) {
                    return FTile(title: const Text('저장된 대화가 없어요'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      return FTile(
                        prefix: const Icon(FLucideIcons.messagesSquare),
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
                        onPress: () {
                          bloc.add(ChatEventSessionSelected(session.id));
                          Navigator.of(sheetContext).pop();
                        },
                      );
                    },
                  );
                },
              ),
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
        return FScaffold(
          header: FHeader.nested(
            suffixes: [
              FHeaderAction(
                icon: const Icon(FLucideIcons.history),
                onPress: _openHistory,
              ),
              FHeaderAction(
                icon: const Icon(FLucideIcons.messageCirclePlus),
                onPress: () {
                  bloc.add(const ChatEventNewSessionStarted());
                },
              ),
            ],
            title: const Text('AI 성경 해설'),
          ),
          child: Column(
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
    final colors = context.theme.colors;
    final body = streaming ? '${message.content}▌' : message.content;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser ? colors.primary : colors.secondary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: SelectableText(
          body,
          style: context.theme.typography.body.md,
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
    final theme = context.theme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FLucideIcons.bookOpen,
              size: 56,
              color: theme.colors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              '무엇이든 물어보세요',
              style: theme.typography.body.lg,
            ),
            const SizedBox(height: 6),
            Text(
              '구절을 언급하면 본문을 찾아 성경적으로 풀어드려요',
              style: theme.typography.body.sm,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                for (final example in _ChatViewState._examples)
                  FButton(
                    variant: FButtonVariant.secondary,
                    size: FButtonSizeVariant.sm,
                    mainAxisSize: MainAxisSize.min,
                    onPress: () => onExampleTap(example),
                    child: Text(
                      example,
                      textAlign: TextAlign.center,
                    ),
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
              child: FTextField(
                control: FTextFieldControl.managed(controller: controller),
                enabled: enabled,
                hint: '질문을 입력하세요',
                minLines: 1,
                maxLines: 5,
              ),
            ),
            const SizedBox(width: 8),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final canSend = enabled && value.text.trim().isNotEmpty;
                return FButton.icon(
                  onPress: canSend ? () => onSubmitted(controller.text) : null,
                  child: const Icon(FLucideIcons.sendHorizontal),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
