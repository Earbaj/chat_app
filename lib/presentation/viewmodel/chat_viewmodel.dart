import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/chat_message_entity.dart';
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

  // DI এর মাধ্যমে SendChatMessageUseCase গ্রহণ করা
  ChatViewModel(this._sendChatMessageUseCase) : super(ChatState.initial());

  /*
  // ----------------------------------------------------
  // PREVIOUS (Non-Streaming sendMessage): পুরো রেসপন্স একসাথে আসার পর দেখায়
  // (শিক্ষার জন্য কমেন্ট করে রাখা হলো)
  // ----------------------------------------------------
  Future<void> sendMessage(String promptText) async {
    final String cleanPrompt = promptText.trim();
    if (cleanPrompt.isEmpty || state.isLoading) return;

    final userMsg = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: cleanPrompt,
      isUser: true,
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      errorMessage: null,
    );

    try {
      final aiReplyMsg = await _sendChatMessageUseCase(cleanPrompt);
      state = state.copyWith(
        messages: [...state.messages, aiReplyMsg],
        isLoading: false,
      );
    } catch (e) {
      final errorMsg = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Error fetching response: $e',
        isUser: false,
      );
      state = state.copyWith(
        messages: [...state.messages, errorMsg],
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
  */

  // ----------------------------------------------------
  // NEW (Streaming sendMessage): ChatGPT-এর মতো রিয়েল-টাইমে টাইপিং লাইভ আপডেট করবে
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

    // ২. AI রেসপন্সের জন্য একটি খালি (Empty) মেসেজ বাব্‌ল তৈরি করা হলো যাতে শব্দগুলো আসার সাথে সাথে এতে যুক্ত হতে পারে
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

        // স্টেট আপডেট করায় UI রিয়েল-টাইমে টাইপিং দেখাবে
        state = state.copyWith(
          messages: updatedMessages,
          isLoading: true,
        );
      }

      // ৫. স্ট্রীম সম্পন্ন হলে লোডিং ইন্ডিকেটর অফ হবে
      state = state.copyWith(isLoading: false);
    } catch (e) {
      // কোনো সমস্যা বা এরর হলে মেসেজ উইজেটে এরর টেক্সট আপডেট করা
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
    }
  }

  /// চ্যাট হিস্ট্রি মুছে ফেলার মেথড
  void clearChat() {
    state = ChatState.initial();
  }
}

/// Riverpod StateNotifierProvider যা পুরো অ্যাপে ChatViewModel কে সরবরাহ করে
final chatViewModelProvider =
    StateNotifierProvider<ChatViewModel, ChatState>((ref) {
  final useCase = ref.watch(sendChatMessageUseCaseProvider);
  return ChatViewModel(useCase);
});
