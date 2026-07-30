import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../domain/entities/chat_message_entity.dart';

/// ---------------------------------------------------------------------------
/// 💬 CHAT BUBBLE WIDGET (চ্যাট বাব্‌ল উইজেট)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// ইউজারের মেসেজ (ডানপাশে) এবং AI এর মেসেজ (বামপাশে) বিভিন্ন রঙ ও ডিজাইনে ডিসপ্লে করে।
/// এতে ৩টি ফিচার যুক্ত আছে:
/// ১. MarkdownBody: ChatGPT এর মতো কোড হাইলাইটিং, বুলেট পয়েন্ট রেন্ডার করার জন্য।
/// ২. Timestamp: মেসেজের নিচে সময় প্রদর্শন (যেমন: 10:45 AM)।
/// ৩. Copy Button: এক ক্লিকে মেসেজটি ক্লিপবোর্ডে কপি করা।
/// ---------------------------------------------------------------------------

class ChatBubbleWidget extends StatelessWidget {
  final ChatMessageEntity message;

  const ChatBubbleWidget({super.key, required this.message});

  /// মেসেজ টেক্সট সিস্টেম ক্লিপবোর্ডে কপি করে SnackBar দেখানো
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: message.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// DateTime কে সুন্দর সময় ফরম্যাটে (e.g. 10:45 AM) রূপান্তর করার হেলপার মেথড
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final colorScheme = Theme.of(context).colorScheme;
    final formattedTime = _formatTime(message.timestamp);

    return Align(
      // ইউজার হলে ডানপাশে, AI হলে বামপাশে অ্যালাইনমেন্ট
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: isUser ? colorScheme.primary : colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            /*
            // ----------------------------------------------------
            // PREVIOUS (Simple Text Widget): প্লেইন টেক্সট দেখায়
            // (শিক্ষার জন্য কমেন্ট করে রাখা হলো)
            // ----------------------------------------------------
            Text(
              message.text,
              style: TextStyle(
                color: isUser ? colorScheme.onPrimary : colorScheme.onSurface,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            */

            // ----------------------------------------------------
            // NEW (MarkdownBody Widget): ChatGPT-এর মতো Rich Formatting
            // (কোড ব্লক, বুলেট লিস্ট, বোল্ড টেক্সট ইত্যাদি রেন্ডার করবে)
            // ----------------------------------------------------
            MarkdownBody(
              data: message.text.isEmpty ? '...' : message.text,
              selectable: true, // সিলেক্ট ও কপি সাপোর্ট
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: TextStyle(
                  color: isUser ? colorScheme.onPrimary : colorScheme.onSurface,
                  fontSize: 15,
                  height: 1.4,
                ),
                code: TextStyle(
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                  fontFamily: 'monospace',
                ),
                codeblockDecoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black54
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 6),
            
            // সময় (Timestamp) ও কপি বাটন (Copy Button)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 10,
                    color: isUser
                        ? colorScheme.onPrimary.withValues(alpha: 0.6)
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _copyToClipboard(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.copy_rounded,
                          size: 12,
                          color: isUser
                              ? colorScheme.onPrimary.withValues(alpha: 0.7)
                              : colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Copy',
                          style: TextStyle(
                            fontSize: 11,
                            color: isUser
                                ? colorScheme.onPrimary.withValues(alpha: 0.7)
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
