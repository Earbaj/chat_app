import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

/// ---------------------------------------------------------------------------
/// ⚡ USE CASE: SendChatMessageUseCase (বিজনেজ লজিক ইউজকেস)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// Clean Architecture-এ প্রতিটি সুনির্দিষ্ট কাজকে (Business Operation) একটি ইউজকেস বলা হয়।
/// উদাহরণ: ইউজারের চ্যাট মেসেজ প্রসেস করা ও এপিআই কল করার আগে চেক করা যে প্রম্পট খালি কিনা।
/// এটি UI (ViewModel) এবং Data Layer (Repository)-এর মাঝে সেতু বন্ধন হিসেবে কাজ করে।
/// ---------------------------------------------------------------------------

class SendChatMessageUseCase {
  final ChatRepository repository;

  SendChatMessageUseCase(this.repository);

  /*
  // ----------------------------------------------------
  // PREVIOUS (Non-Streaming Call): পুরো উত্তর না পাওয়া পর্যন্ত ওয়েট করে
  // (শিক্ষার জন্য কমেন্ট করে রাখা হলো)
  // ----------------------------------------------------
  Future<ChatMessageEntity> call(String topic) async {
    if (topic.trim().isEmpty) {
      throw Exception('Topic prompt cannot be empty');
    }
    return await repository.fetchAiResponse(topic);
  }
  */

  // ----------------------------------------------------
  // NEW (Streaming Execution): রিয়েল-টাইমে শব্দ বাই শব্দ স্ট্রিম রেসপন্স পাঠায়
  // ----------------------------------------------------
  Stream<String> executeStream(String topic) {
    // প্রম্পট খালি কিনা ভ্যালিডেশন
    if (topic.trim().isEmpty) {
      throw Exception('Topic prompt cannot be empty');
    }
    // রিপোজিটরি থেকে এপিআই স্ট্রীম কল করা
    return repository.fetchAiResponseStream(topic);
  }
}
