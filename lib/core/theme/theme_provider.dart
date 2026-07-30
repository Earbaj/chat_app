import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ---------------------------------------------------------------------------
/// 🌓 DYNAMIC THEME NOTIFIER (থিম স্টেট নোটিফায়ার)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// এটি অ্যাপের থিম মোড (Light, Dark, বা System Default) মেমোরিতে ধরে রাখে এবং
/// toggleTheme() মেথডটি ডায়নামিকভাবে Light থেকে Dark বা Dark থেকে Light মোডে সুইপিং পরিচালনা করে।
/// ---------------------------------------------------------------------------

class ThemeNotifier extends StateNotifier<ThemeMode> {
  // ডিফল্ট থিম হিসেবে সিস্টেম থিম নির্ধারণ করা হয়েছে
  ThemeNotifier() : super(ThemeMode.system);

  /// ডার্ক ও লাইট থিমের মধ্যে সুইপিং করার মেথড
  void toggleTheme() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.dark;
    }
  }

  /// নির্দিষ্ট থিম মোড সেট করার মেথড
  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

/// Riverpod-এর StateNotifierProvider যা পুরো অ্যাপে থিম মোড রিড করতে এবং টগল করতে সাহায্য করে
final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
