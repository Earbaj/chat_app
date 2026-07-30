import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// ✏️ CHAT INPUT FIELD WIDGET (চ্যাট ইনপুট ফিল্ড উইজেট)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// এটি চ্যাট স্ক্রিনের নিচে অবস্থিত ইনপুট বক্স এবং সেন্ড বাটন।
/// AI যখন উত্তর জেনারেট করে (isLoading = true), তখন ইনপুট ফিল্ড ও বাটন ডিসেবল থাকে।
/// ---------------------------------------------------------------------------

class ChatInputField extends StatelessWidget {
  final TextEditingController controller; // ইনপুট টেক্সট কন্ট্রোলার
  final VoidCallback onSend;              // সেন্ড বাটন প্রেস করার কলব্যাক মেথড
  final bool isLoading;                   // AI লোডিং স্টেট flag

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // প্রম্পট লেখার ইনপুট ফিল্ড
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter a topic (e.g. Flutter, Space)...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => onSend(), // কিবোর্ডের Enter বাটন চাপলে সেন্ড হবে
              enabled: !isLoading,         // AI লোড হওয়ার সময় ইনপুট ডিজেবল রাখা
            ),
          ),
          
          // সেন্ড বাটন
          IconButton.filled(
            onPressed: isLoading ? null : onSend, // AI লোড হওয়ার সময় বাটন ডিজেবল রাখা
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
