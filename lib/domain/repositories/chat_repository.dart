import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<ChatMessageEntity> fetchAiResponse(String topic);
}
