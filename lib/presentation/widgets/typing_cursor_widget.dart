import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// ⚡ TYPING CURSOR WIDGET (জেমিনি স্টাইল ব্লিঙ্কিং কার্সর উইজেট)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// Gemini বা ChatGPT অ্যাপে এআই যখন রিয়েল-টাইমে টাইপ করে, তখন লেখার শেষে একটি
/// সুন্দর ব্লিঙ্কিং কার্সর (`▌`) বা কাস্টম বার অ্যানিমেট হয়।
/// ---------------------------------------------------------------------------

class TypingCursorWidget extends StatefulWidget {
  const TypingCursorWidget({super.key});

  @override
  State<TypingCursorWidget> createState() => _TypingCursorWidgetState();
}

class _TypingCursorWidgetState extends State<TypingCursorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // ব্লিঙ্কিং রিপিটিং অ্যানিমেশন কন্ট্রোলার (৫০০ মিলি-সেকেন্ড পরপর)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        margin: const EdgeInsets.only(left: 4),
        width: 8,
        height: 15,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
