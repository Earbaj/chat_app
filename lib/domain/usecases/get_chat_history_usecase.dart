import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

/// ---------------------------------------------------------------------------
/// ⚡ USE CASE: GetChatHistoryUseCase (ক্যাশড চ্যাট হিস্ট্রি পাওয়ার ইউজকেস)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// অ্যাপ চালু হওয়ার সময় SharedPreferences থেকে সেভ থাকা অতীত চ্যাট মেসেজ
/// লোড করতে এই ইউজকেসটি ব্যবহার করা হয়।
/// ---------------------------------------------------------------------------

class GetChatHistoryUseCase {
  final ChatRepository repository;

  GetChatHistoryUseCase(this.repository);

  Future<List<ChatMessageEntity>> call() async {
    return await repository.getChatHistory();
  }
}
