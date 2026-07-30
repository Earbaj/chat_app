import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

/// ---------------------------------------------------------------------------
/// ⚡ USE CASE: SaveChatHistoryUseCase (চ্যাট হিস্ট্রি লোকালি সেভ করার ইউজকেস)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// নতুন মেসেজ যুক্ত হওয়ার পর বা AI রেসপন্স শেষ হওয়ার পর চ্যাট হিস্ট্রি
/// লোকাল ডিভাইসে সংরক্ষণের জন্য এই ইউজকেসটি কাজ করে।
/// ---------------------------------------------------------------------------

class SaveChatHistoryUseCase {
  final ChatRepository repository;

  SaveChatHistoryUseCase(this.repository);

  Future<void> call(List<ChatMessageEntity> messages) async {
    await repository.saveChatHistory(messages);
  }
}
