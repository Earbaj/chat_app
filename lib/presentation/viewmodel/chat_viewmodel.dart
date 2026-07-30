import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';
import '../state/chat_state.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  final SendChatMessageUseCase _sendChatMessageUseCase;

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
  // NEW (Streaming sendMessageStream): ChatGPT-এর মতো রিয়েল-টাইমে টাইপিং লাইভ আপডেট করবে
  // ----------------------------------------------------
  Future<void> sendMessage(String promptText) async {
    final String cleanPrompt = promptText.trim();
    if (cleanPrompt.isEmpty || state.isLoading) return;

    // ১. প্রথমে ইউজারের মেসেজ যুক্ত করা হলো
    final userMsg = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: cleanPrompt,
      isUser: true,
    );

    // ২. একটি ফাঁকা (Empty) AI মেসেজ যুক্ত করা হলো যাতে শব্দ আসার সাথে সাথে এটি রিয়েল-টাইমে আপডেট হতে পারে
    final String aiMessageId = (DateTime.now().millisecondsSinceEpoch + 1).toString();
    final aiPlaceholderMsg = ChatMessageEntity(
      id: aiMessageId,
      text: '',
      isUser: false,
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg, aiPlaceholderMsg],
      isLoading: true,
      errorMessage: null,
    );

    String accumulatedText = '';

    try {
      final stream = _sendChatMessageUseCase.executeStream(cleanPrompt);

      await for (final chunk in stream) {
        accumulatedText += chunk;

        // ৩. প্রতিবার নতুন চাংক আসার সাথে সাথে লিস্টের শেষ AI মেসেজটি আপডেট করা হচ্ছে
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

      // স্ট্রিম সমাপ্ত হলে লোডিং বন্ধ হবে
      state = state.copyWith(isLoading: false);
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
    }
  }

  void clearChat() {
    state = ChatState.initial();
  }
}

// Riverpod Provider for ViewModel (Injecting UseCase from DI container)
final chatViewModelProvider =
    StateNotifierProvider<ChatViewModel, ChatState>((ref) {
  final useCase = ref.watch(sendChatMessageUseCaseProvider);
  return ChatViewModel(useCase);
});
