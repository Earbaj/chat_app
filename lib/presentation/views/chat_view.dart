import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/chat_viewmodel.dart';
import '../widgets/chat_bubble_widget.dart';
import '../widgets/chat_input_field.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _textController.text;
    if (text.trim().isEmpty) return;

    _textController.clear();
    ref.read(chatViewModelProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatViewModelProvider);

    // Auto scroll when messages list updates
    ref.listen(chatViewModelProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Topic Assistant'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Chat Messages Display
          Expanded(
            child: chatState.messages.isEmpty
                ? const Center(
                    child: Text(
                      'write topic name and send',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      final item = chatState.messages[index];
                      return ChatBubbleWidget(message: item);
                    },
                  ),
          ),

          // Loading Indicator
          if (chatState.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Gemini Thinking...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

          // Input Field
          ChatInputField(
            controller: _textController,
            onSend: _sendMessage,
            isLoading: chatState.isLoading,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
