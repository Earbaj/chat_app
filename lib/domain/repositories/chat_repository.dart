import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  // ----------------------------------------------------
  // PREVIOUS (Non-Streaming Method - Future)
  // ----------------------------------------------------
  // Future<ChatMessageEntity> fetchAiResponse(String topic);

  // ----------------------------------------------------
  // NEW (Streaming Method - Stream)
  // ----------------------------------------------------
  Stream<String> fetchAiResponseStream(String topic);
}
