import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../domain/entities/chat_message_entity.dart';
import 'typing_cursor_widget.dart';

/// ---------------------------------------------------------------------------
/// 💬 CHAT BUBBLE WIDGET (অফিসিয়াল Gemini স্টাইল চ্যাট বাব্‌ল উইজেট)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// ইউজারের মেসেজ (ডানপাশে 👤) এবং AI এর মেসেজ (বামপাশে 🤖) দৃষ্টিনন্দন অ্যাভাটার,
/// মার্জিত বাবল কালার এবং লাইভ টাইপিংয়ের ব্লিঙ্কিং কার্সর (`▌`) সহ ডিসপ্লে করে।
/// ---------------------------------------------------------------------------

class ChatBubbleWidget extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isStreaming; // AI রিয়েল-টাইমে টাইপ করছে কিনা (Cursor show করার জন্য)

  const ChatBubbleWidget({
    super.key,
    required this.message,
    this.isStreaming = false,
  });

  /// মেসেজ টেক্সট সিস্টেম ক্লিপবোর্ডে কপি করা
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

  /// DateTime কে সুন্দর সময় ফরম্যাটে (e.g. 10:45 AM) রূপান্তর
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

    // ১. ইউজার ও AI এর জন্য পৃথক অ্যাভাটার উইজেট
    final avatarWidget = CircleAvatar(
      radius: 16,
      backgroundColor: isUser
          ? colorScheme.primaryContainer
          : colorScheme.secondaryContainer,
      child: Icon(
        isUser ? Icons.person_rounded : Icons.auto_awesome_rounded,
        size: 18,
        color: isUser
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSecondaryContainer,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI অ্যাভাটার (বামপাশে)
          if (!isUser) ...[
            avatarWidget,
            const SizedBox(width: 8),
          ],

          // চ্যাট মেসেজ বাব্‌ল
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.78,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHigh,
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
                  // Rich Text Markdown Rendering + Blinking Cursor (AI Streaming এর সময়)
                  Wrap(
                    cross: WrapCrossAlignment.center,
                    children: [
                      MarkdownBody(
                        data: message.text.isEmpty && isStreaming
                            ? ''
                            : (message.text.isEmpty ? '...' : message.text),
                        selectable: true,
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                          p: TextStyle(
                            color: isUser
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
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
                      
                      // AI রিয়েল-টাইমে টাইপ করার সময় ব্লিঙ্কিং কার্সর (Typing Cursor)
                      if (!isUser && isStreaming) const TypingCursorWidget(),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // সময় ও কপি বাটন
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
          ),

          // User অ্যাভাটার (ডানপাশে)
          if (isUser) ...[
            const SizedBox(width: 8),
            avatarWidget,
          ],
        ],
      ),
    );
  }
}
