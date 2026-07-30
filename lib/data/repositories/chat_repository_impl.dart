import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_message_model.dart';

/// ---------------------------------------------------------------------------
/// 🛠️ DATA REPOSITORY IMPLEMENTATION: ChatRepositoryImpl
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// Domain Layer-এ যে ChatRepository interface তৈরি করা হয়েছিল,
/// এই ক্লাসে সেটি Implement করা হয়েছে।
/// এটি Data Source (Remote & Local) থেকে প্রাপ্ত তথ্যে ডোমেইন লেয়ারে সরবরাহ করে।
/// ---------------------------------------------------------------------------

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

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
  // STREAMING IMPLEMENTATION (এপিআই থেকে স্ট্রীম ডেটা ডোমেইনে ফরোয়ার্ড করে)
  // ----------------------------------------------------
  @override
  Stream<String> fetchAiResponseStream(String topic) {
    return remoteDataSource.sendTopicPromptStream(topic);
  }

  // ----------------------------------------------------
  // LOCAL CACHING IMPLEMENTATION
  // ----------------------------------------------------
  @override
  Future<void> saveChatHistory(List<ChatMessageEntity> messages) async {
    final models = messages
        .map((e) => ChatMessageModel(
              id: e.id,
              text: e.text,
              isUser: e.isUser,
              timestamp: e.timestamp,
            ))
        .toList();
    await localDataSource.cacheChatHistory(models);
  }

  @override
  Future<List<ChatMessageEntity>> getChatHistory() async {
    return await localDataSource.getCachedChatHistory();
  }

  @override
  Future<void> clearChatHistory() async {
    await localDataSource.clearCachedChatHistory();
  }
}
