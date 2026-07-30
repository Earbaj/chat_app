import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/get_chat_history_usecase.dart';
import '../../domain/usecases/save_chat_history_usecase.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';
import '../state/chat_state.dart';

/// ---------------------------------------------------------------------------
/// 🔄 PRESENTATION VIEWMODEL: ChatViewModel (স্টেট নোটিফায়ার ও প্রেজেন্টেশন লজিক)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// MVVM আর্কিটেকচারে ViewModel ইউআই-এর স্টেট (State) ম্যানেজ করে এবং ইউজার অ্যাকশন প্রসেস করে।
/// Riverpod-এর `StateNotifier<ChatState>` ব্যবহার করে স্টেটের পরিবর্তনের সাথে সাথে
/// ইউআই স্বয়ংক্রিয়ভাবে রি-রেন্ডার হয়।
/// ---------------------------------------------------------------------------

class ChatViewModel extends StateNotifier<ChatState> {
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final GetChatHistoryUseCase _getChatHistoryUseCase;
  final SaveChatHistoryUseCase _saveChatHistoryUseCase;

  ChatViewModel(
    this._sendChatMessageUseCase,
    this._getChatHistoryUseCase,
    this._saveChatHistoryUseCase,
  ) : super(ChatState.initial()) {
    // ViewModel তৈরি হওয়ার সাথে সাথে লোকাল ক্যাশ থেকে চ্যাট হিস্ট্রি লোড হবে
    _loadCachedHistory();
  }

  /// ১. SharedPreferences থেকে সেভ থাকা অতীত চ্যাট মেসেজ লোড করার মেথড
  Future<void> _loadCachedHistory() async {
    try {
      final cachedMessages = await _getChatHistoryUseCase();
      if (cachedMessages.isNotEmpty) {
        state = state.copyWith(messages: cachedMessages);
      }
    } catch (_) {}
  }

  // ----------------------------------------------------
  // STREAMING sendMessage: ChatGPT/Gemini-এর মতো রিয়েল-টাইমে টাইপিং এবং ক্যাশিং সাপোর্ট
  // ----------------------------------------------------
  Future<void> sendMessage(String promptText) async {
    final String cleanPrompt = promptText.trim();
    if (cleanPrompt.isEmpty || state.isLoading) return;

    // ১. ইউজার যে প্রশ্ন পাঠিয়েছে তা মেমোরিতে যুক্ত করা হলো
    final userMsg = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: cleanPrompt,
      isUser: true,
    );

    // ২. AI রেসপন্সের জন্য একটি খালি (Empty) মেসেজ বাব্‌ল তৈরি করা হলো
    final String aiMessageId = (DateTime.now().millisecondsSinceEpoch + 1).toString();
    final aiPlaceholderMsg = ChatMessageEntity(
      id: aiMessageId,
      text: '',
      isUser: false,
    );

    // স্টেট আপডেট (ইউজারের মেসেজ + খালি AI মেসেজ যুক্ত করা)
    state = state.copyWith(
      messages: [...state.messages, userMsg, aiPlaceholderMsg],
      isLoading: true,
      errorMessage: null,
    );

    String accumulatedText = '';

    try {
      // ৩. UseCase থেকে রিয়েল-টাইম স্ট্রীম সাবস্ক্রাইব করা হলো
      final stream = _sendChatMessageUseCase.executeStream(cleanPrompt);

      // ৪. স্ট্রীমের প্রতিটি শব্দ/চাংক (chunk) আসার সাথে সাথে লাইভ স্টেট আপডেট করা হচ্ছে
      await for (final chunk in stream) {
        accumulatedText += chunk;

        final updatedMessages = state.messages.map((msg) {
          if (msg.id == aiMessageId) {
            return ChatMessageEntity(
              id: msg.id,
              text: accumulatedText,
              isUser: false,
              timestamp: msg.timestamp,
            );
          }
          return msg;
        }).toList();

        state = state.copyWith(
          messages: updatedMessages,
          isLoading: true,
        );
      }

      // ৫. স্ট্রীম সম্পন্ন হলে লোডিং বন্ধ হবে এবং চ্যাট হিস্ট্রি লোকালি সেভ করা হবে
      state = state.copyWith(isLoading: false);
      await _saveChatHistoryUseCase(state.messages);
    } catch (e) {
      final updatedMessages = state.messages.map((msg) {
        if (msg.id == aiMessageId) {
          return ChatMessageEntity(
            id: msg.id,
            text: accumulatedText.isNotEmpty
                ? '$accumulatedText\n\n[Error: $e]'
                : 'Error fetching response: $e',
            isUser: false,
            timestamp: msg.timestamp,
          );
        }
        return msg;
      }).toList();

      state = state.copyWith(
        messages: updatedMessages,
        isLoading: false,
        errorMessage: e.toString(),
      );
      await _saveChatHistoryUseCase(state.messages);
    }
  }

  /// চ্যাট হিস্ট্রি মুছে ফেলার মেথড (স্টেট ও লোকাল ক্যাশ উভয়ই ক্লিয়ার হবে)
  Future<void> clearChat() async {
    state = ChatState.initial();
    await _saveChatHistoryUseCase([]);
  }
}

/// Riverpod StateNotifierProvider যা পুরো অ্যাপে ChatViewModel কে সরবরাহ করে
final chatViewModelProvider =
    StateNotifierProvider<ChatViewModel, ChatState>((ref) {
  final sendUseCase = ref.watch(sendChatMessageUseCaseProvider);
  final getHistoryUseCase = ref.watch(getChatHistoryUseCaseProvider);
  final saveHistoryUseCase = ref.watch(saveChatHistoryUseCaseProvider);
  return ChatViewModel(sendUseCase, getHistoryUseCase, saveHistoryUseCase);
});
