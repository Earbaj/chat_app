/// ---------------------------------------------------------------------------
/// 🧩 DOMAIN ENTITY: ChatMessageEntity (ডোমেইন লেয়ার মেসেজ এনটিটি)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// Clean Architecture-এ Entity হলো ডোমেইন লেয়ারের সবচেয়ে পিউর (Pure) অবজেক্ট।
/// এটিতে কোনো থার্ডপার্টি প্যাকেজ বা API নির্ভরতা থাকবে না।
/// চ্যাট মেসেজের মূল ডেটা স্ট্রাকচার হিসেবে এটি কাজ করে।
/// ---------------------------------------------------------------------------

class ChatMessageEntity {
  final String id;          // মেসেজের ইউনিক আইডি
  final String text;        // মেসেজের মূল লেখা
  final bool isUser;        // ইউজারের পাঠানো মেসেজ নাকি AI এর রেসপন্স (true = User, false = AI)
  final DateTime timestamp; // মেসেজ পাঠানোর সময়

  ChatMessageEntity({
    required this.id,
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now(); // কোনো সময় দেওয়া না থাকলে বর্তমান সময় নেওয়া হবে
}
