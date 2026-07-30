import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class SendChatMessageUseCase {
  final ChatRepository repository;

  SendChatMessageUseCase(this.repository);

  /*
  // ----------------------------------------------------
  // PREVIOUS (Non-Streaming Call): পুরো উত্তর না পাওয়া পর্যন্ত ওয়েট করে
  // ----------------------------------------------------
  Future<ChatMessageEntity> call(String topic) async {
    if (topic.trim().isEmpty) {
      throw Exception('Topic prompt cannot be empty');
    }
    return await repository.fetchAiResponse(topic);
  }
  */

  // ----------------------------------------------------
  // NEW (Streaming Execution): রিয়েল-টাইমে স্ট্রিম চাংক পাঠায়
  // ----------------------------------------------------
  Stream<String> executeStream(String topic) {
    if (topic.trim().isEmpty) {
      throw Exception('Topic prompt cannot be empty');
    }
    return repository.fetchAiResponseStream(topic);
  }
}
