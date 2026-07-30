import 'package:flutter/material.dart';
import 'package:dartantic_ai/dartantic_ai.dart';

void main() {
  runApp(const MyChatApp());
}

class MyChatApp extends StatelessWidget {
  const MyChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

// ----------------------------------------------------
// ১. চ্যাট বার্তা মডেল (Message Model)
// ----------------------------------------------------
class ChatBubbleItem {
  final String text;
  final bool isUser;

  ChatBubbleItem({required this.text, required this.isUser});
}

// ----------------------------------------------------
// ২. API কল ফাংশন
// ----------------------------------------------------
const String myApiKey = 'AIzaSyAbca7OBztaW1xq61hw2MtUhV7gDu673xs';

Future<String> fetchAiResponse(String topic) async {
  final provider = GoogleProvider(apiKey: myApiKey);
  final agent = Agent.forProvider(
    provider,
    chatModelName: 'gemini-3-flash-preview',
  );

  final response = await agent.send('Give me details about $topic');
  return response.output;
}

// ----------------------------------------------------
// ৩. চ্যাট স্ক্রিন UI (ChatScreen)
// ----------------------------------------------------
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatBubbleItem> _messages = [];
  bool _isLoading = false;

  // 🔹 মেসেজ সেন্ড করার ফাংশন
  Future<void> _sendMessage() async {
    final String prompt = _textController.text.trim();
    if (prompt.isEmpty || _isLoading) return;

    _textController.clear();

    // ১. ইউজারের মেসেজ চ্যাট লিস্টে যোগ করা
    setState(() {
      _messages.add(ChatBubbleItem(text: prompt, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    // ২. API থেকে AI উত্তর নিয়ে আসা
    try {
      final String aiReply = await fetchAiResponse(prompt);
      setState(() {
        _messages.add(ChatBubbleItem(text: aiReply, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(
          ChatBubbleItem(text: "Error fetching response: $e", isUser: false),
        );
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  // 🔹 চ্যাট লিস্ট অটো স্ক্রোল করে নিচে নামানো
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Topic Assistant'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔝 ১. চ্যাট মেসেজ ডিসপ্লে এলাকা (ListView)
          Expanded(
            child: _messages.isEmpty
                ? const Center(
              child: Text(
                'নিচে টপিকের নাম লিখে সেন্ড করুন...',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final item = _messages[index];
                return _buildChatBubble(item);
              },
            ),
          ),

          // ⏳ লোডিং ইন্ডিকেটর (AI যখন ভাবছে)
          if (_isLoading)
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

          // 🔻 ২. নিচে ইনপুট ফিল্ড ও সেন্ড বাটন
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a topic (e.g. Flutter, Space)...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    enabled: !_isLoading,
                  ),
                ),
                IconButton.filled(
                  onPressed: _isLoading ? null : _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 চ্যাট বাবল ডিজাইন করার উইজেট
  Widget _buildChatBubble(ChatBubbleItem item) {
    return Align(
      alignment: item.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: item.isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: item.isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: item.isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Text(
          item.text,
          style: TextStyle(
            color: item.isUser
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontSize: 15,
            height: 1.4,
          ),
        ),
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
