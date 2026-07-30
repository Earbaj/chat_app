import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.text,
    required super.isUser,
    super.timestamp,
  });

  factory ChatMessageModel.fromAiResponse(String responseText, String id) {
    return ChatMessageModel(
      id: id,
      text: responseText,
      isUser: false,
    );
  }

  factory ChatMessageModel.fromUserPrompt(String prompt, String id) {
    return ChatMessageModel(
      id: id,
      text: prompt,
      isUser: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
