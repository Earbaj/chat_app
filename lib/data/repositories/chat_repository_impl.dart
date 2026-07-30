import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

/// ---------------------------------------------------------------------------
/// 🛠️ DATA REPOSITORY IMPLEMENTATION: ChatRepositoryImpl
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// Domain Layer-এ যে ChatRepository interface তৈরি করা হয়েছিল,
/// এই ক্লাসে সেটি Implement করা হয়েছে।
/// এটি Data Source (ChatRemoteDataSource) থেকে প্রাপ্ত তথ্যে ডোমেইন লেয়ারে সরবরাহ করে।
/// ---------------------------------------------------------------------------

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
  // NEW STREAMING IMPLEMENTATION (এপিআই থেকে স্ট্রীম ডেটা ডোমেইনে ফরোয়ার্ড করে)
  // ----------------------------------------------------
  @override
  Stream<String> fetchAiResponseStream(String topic) {
    return remoteDataSource.sendTopicPromptStream(topic);
  }
}
