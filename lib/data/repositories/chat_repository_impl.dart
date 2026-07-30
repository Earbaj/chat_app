import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  /*
  // ----------------------------------------------------
  // PREVIOUS NON-STREAMING IMPLEMENTATION (শিক্ষার জন্য কমেন্ট করা হলো)
  // ----------------------------------------------------
  @override
  Future<ChatMessageEntity> fetchAiResponse(String topic) async {
    return await remoteDataSource.sendTopicPrompt(topic);
  }
  */

  // ----------------------------------------------------
  // NEW STREAMING IMPLEMENTATION
  // ----------------------------------------------------
  @override
  Stream<String> fetchAiResponseStream(String topic) {
    return remoteDataSource.sendTopicPromptStream(topic);
  }
}
