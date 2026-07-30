import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message_model.dart';

/// ---------------------------------------------------------------------------
/// 💾 LOCAL DATA SOURCE: ChatLocalDataSource (লোকাল ক্যাশিং সোর্স)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// এটি SharedPreferences ব্যবহার করে চ্যাট মেসেজগুলো JSON আকারে ফোনে সেভ করে রাখে।
/// অ্যাপ বন্ধ করে পুনরায় ওপেন করা হলে এটি ফোনের স্টোরেজ থেকে চ্যাট ইতিহাস রিড করে।
/// ---------------------------------------------------------------------------

abstract class ChatLocalDataSource {
  Future<void> cacheChatHistory(List<ChatMessageModel> messages);
  Future<List<ChatMessageModel>> getCachedChatHistory();
  Future<void> clearCachedChatHistory();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const String _cachedChatKey = 'CACHED_CHAT_HISTORY_KEY';

  @override
  Future<void> cacheChatHistory(List<ChatMessageModel> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        messages.map((msg) => msg.toJson()).toList();
    final String jsonString = jsonEncode(jsonList);
    await prefs.setString(_cachedChatKey, jsonString);
  }

  @override
  Future<List<ChatMessageModel>> getCachedChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_cachedChatKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decodedList = jsonDecode(jsonString);
      return decodedList
          .map((item) => ChatMessageModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> clearCachedChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedChatKey);
  }
}
