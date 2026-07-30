import '../../domain/entities/chat_message_entity.dart';

/// ---------------------------------------------------------------------------
/// 📊 PRESENTATION STATE: ChatState (ইউআই এর ইমিউটেবল স্টেট)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// Riverpod-এ ইমিউটেবল (Immutable) স্টেট ডেটা মডেল ব্যবহার করা হয়।
/// এর অর্থ হলো স্টেটের মান সরাসরি পরিবর্তন না করে `copyWith()` মেথড ব্যবহার করে
/// নতুন একটি স্টেট অবজেক্ট তৈরি করে UI রি-রেন্ডার করা হয়।
/// ---------------------------------------------------------------------------

class ChatState {
  final List<ChatMessageEntity> messages; // চ্যাট মেসেজসমূহের লিস্ট
  final bool isLoading;                   // AI উত্তর জেনারেট হচ্ছে কিনা (Loading indicator flag)
  final String? errorMessage;             // কোনো এরর বা ত্রুটি থাকলে তার মেসেজ

  ChatState({
    required this.messages,
    this.isLoading = false,
    this.errorMessage,
  });

  /// অ্যাপ শুরুতে প্রাথমিক স্টেট তৈরির জন্য ফ্যাক্টরি কনস্ট্রাক্টর
  factory ChatState.initial() {
    return ChatState(
      messages: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  /// স্টেট পরিবর্তন না করে আংশিক মান পরিবর্তন করে নতুন অবজেক্ট তৈরির মেথড
  ChatState copyWith({
    List<ChatMessageEntity>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
