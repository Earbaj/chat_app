import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';
import '../state/chat_state.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  final SendChatMessageUseCase _sendChatMessageUseCase;

  ChatViewModel(this._sendChatMessageUseCase) : super(ChatState.initial());

  Future<void> sendMessage(String promptText) async {
    final String cleanPrompt = promptText.trim();
    if (cleanPrompt.isEmpty || state.isLoading) return;

    // Add user message to UI state immediately
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
