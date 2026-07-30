import '../../domain/entities/chat_message_entity.dart';

/// ---------------------------------------------------------------------------
/// 📄 DATA MODEL: ChatMessageModel (ডেটা লেয়ারের ডেটা মডেল)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// Data Model হলো Domain Entity-র একটি বর্ধিত রূপ (Extension)।
/// এটি API রেসপন্স থেকে JSON বা ডেটা রিসিভ করে এবং প্রয়োজনমতো Serialization/Deserialization করে।
/// ---------------------------------------------------------------------------

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.text,
    required super.isUser,
    super.timestamp,
  });

  /// Gemini AI রেসপন্স থেকে মডেল অবজেক্ট তৈরির ফ্যাক্টরি কনস্ট্রাক্টর
  factory ChatMessageModel.fromAiResponse(String responseText, String id) {
    return ChatMessageModel(
      id: id,
      text: responseText,
      isUser: false,
    );
  }

  /// ইউজারের প্রম্পট থেকে মডেল অবজেক্ট তৈরির ফ্যাক্টরি কনস্ট্রাক্টর
  factory ChatMessageModel.fromUserPrompt(String prompt, String id) {
    return ChatMessageModel(
      id: id,
      text: prompt,
      isUser: true,
    );
  }

  /// JSON ম্যাপ থেকে মডেল অবজেক্ট তৈরির ফ্যাক্টরি কনস্ট্রাক্টর (Local Caching Deserialization)
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// লোকাল ডেটাবেজ বা লোকাল স্টোরেজে সংরক্ষণের জন্য JSON ম্যাপ এ রূপান্তর (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
