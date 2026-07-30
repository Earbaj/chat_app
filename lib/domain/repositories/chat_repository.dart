import '../entities/chat_message_entity.dart';

/// ---------------------------------------------------------------------------
/// 📋 DOMAIN REPOSITORY INTERFACE: ChatRepository
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// এটি একটি Abstract Class (ইন্টারফেস বা কন্ট্রাক্ট)।
/// ডোমেইন লেয়ার নির্দেশ দেয় "কী কী ডেটা অপারেশন করা সম্ভব", কিন্তু "কীভাবে তা করা হবে"
/// তার লজিক Data Layer-এ ChatRepositoryImpl ফাইলে লেখা হয়।
/// ---------------------------------------------------------------------------

abstract class ChatRepository {
  /*
  // ----------------------------------------------------
  // PREVIOUS (Non-Streaming Method - Future):
  // পুরো উত্তর না আসা পর্যন্ত অপেক্ষা করে একসাথে পাঠায়
  // (শিক্ষার জন্য কমেন্ট করে রাখা হলো)
  // ----------------------------------------------------
  Future<ChatMessageEntity> fetchAiResponse(String topic);
  */

  // ----------------------------------------------------
  // Streaming Method - Real-time AI response
  // ----------------------------------------------------
  Stream<String> fetchAiResponseStream(String topic);

  // ----------------------------------------------------
  // Local Caching Methods - চ্যাট হিস্ট্রি ক্যাশিং
  // ----------------------------------------------------
  Future<void> saveChatHistory(List<ChatMessageEntity> messages);
  Future<List<ChatMessageEntity>> getChatHistory();
  Future<void> clearChatHistory();
}
