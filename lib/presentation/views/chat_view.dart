import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';
import '../viewmodel/chat_viewmodel.dart';
import '../widgets/chat_bubble_widget.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/suggestion_chips_widget.dart';

/// ---------------------------------------------------------------------------
/// 🖥️ MAIN VIEW: ChatView (চ্যাট অ্যাপ্লিকেশন স্ক্রিন ভিউ)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// এটি অ্যাপের প্রধান UI স্ক্রিন। ConsumerStatefulWidget ব্যবহার করা হয়েছে যাতে
/// Riverpod Provider-এর স্টেট রিড (ref.watch) এবং লিসেন (ref.listen) করে UI রেন্ডার করা যায়।
/// ---------------------------------------------------------------------------

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  // টেক্সট ফিল্ড ও স্ক্রল কন্ট্রোলার
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  /// মেসেজ পাঠানোর মেথড (ইনপুট বক্স থেকে)
  void _sendMessage() {
    final text = _textController.text;
    if (text.trim().isEmpty) return;

    _textController.clear();
    // Riverpod ViewModel-এর sendMessage মেথড কল করা
    ref.read(chatViewModelProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  /// সাজেশন চিপসে ক্লিক করলে প্রম্পট পাঠানোর মেথড
  void _onSelectSuggestion(String topic) {
    ref.read(chatViewModelProvider.notifier).sendMessage(topic);
    _scrollToBottom();
  }

  /// চ্যাট লিস্ট স্বয়ংক্রিয়ভাবে নিচে স্ক্রল করানোর হেলপার মেথড
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

  /// চ্যাট হিস্ট্রি মুছে ফেলার আগে ইউজার কনফার্মেশন ডায়ালগ
  void _confirmClearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text('Are you sure you want to delete all chat messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(chatViewModelProvider.notifier).clearChat();
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ১. Riverpod-এর মাধ্যমে চ্যাট স্টেট এবং থিম মোড অবজার্ভ করা
    final chatState = ref.watch(chatViewModelProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final isDark = themeMode == ThemeMode.dark;

    // ২. নতুন মেসেজ যুক্ত হলে বা স্ট্রীমিং অক্ষরের মান বাড়লে অটো-স্ক্রল লিসেনার
    ref.listen(chatViewModelProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length ||
          (next.messages.isNotEmpty &&
              previous?.messages.lastOrNull?.text.length !=
                  next.messages.lastOrNull?.text.length)) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Topic Assistant'),
        centerTitle: true,
        actions: [
          // থিম সুইচার বাটন (Dark/Light Mode)
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            tooltip: isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
            onPressed: () {
              ref.read(themeNotifierProvider.notifier).toggleTheme();
            },
          ),
          // চ্যাট ক্লিয়ার বাটন (মেসেজ থাকলে দেখাবে)
          if (chatState.messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear Chat',
              onPressed: _confirmClearChat,
            ),
        ],
      ),
      body: Column(
        children: [
          // ১. চ্যাট মেসেজ ও সাজেশন চিপস লেআউট
          Expanded(
            child: chatState.messages.isEmpty
                ? Center(
                    child: SuggestionChipsWidget(
                      onSelectTopic: _onSelectSuggestion,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      final item = chatState.messages[index];
                      final isLastMessage = index == chatState.messages.length - 1;
                      final isStreamingNow = isLastMessage && chatState.isLoading && !item.isUser;
                      
                      return ChatBubbleWidget(
                        message: item,
                        isStreaming: isStreamingNow,
                      );
                    },
                  ),
          ),


          // ২. লোডিং ইন্ডিকেটর (Gemini Thinking...)
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

          // ৩. নিচে ইনপুট ফিল্ড ও সেন্ড বাটন
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
