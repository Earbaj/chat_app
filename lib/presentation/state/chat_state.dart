import '../../domain/entities/chat_message_entity.dart';

class ChatState {
  final List<ChatMessageEntity> messages;
  final bool isLoading;
  final String? errorMessage;

  ChatState({
    required this.messages,
    this.isLoading = false,
    this.errorMessage,
  });

  factory ChatState.initial() {
    return ChatState(
      messages: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  ChatState copyWith({
    List<ChatMessageEntity>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
