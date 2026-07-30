import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class SendChatMessageUseCase {
  final ChatRepository repository;

  SendChatMessageUseCase(this.repository);

  Future<ChatMessageEntity> call(String topic) async {
    if (topic.trim().isEmpty) {
      throw Exception('Topic prompt cannot be empty');
    }
    return await repository.fetchAiResponse(topic);
  }
}
