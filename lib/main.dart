import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/theme_provider.dart';
import 'presentation/views/chat_view.dart';

/// ---------------------------------------------------------------------------
/// 🚀 MAIN ENTRY POINT (অ্যাপ্লিকেশনের মূল এন্ট্রি পয়েন্ট)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য নির্দেশিকা:
/// ১. WidgetsFlutterBinding.ensureInitialized() ফ্ল্যাটার ফ্রেমওয়ার্ক ইনিশিয়ালাইজ করে।
/// ২. dotenv.load() ব্যবহার করে `.env` ফাইল থেকে গোপন API Key লোড করা হয়।
/// ৩. ProviderScope রুট উইজেটে ব্যবহার করা হয় যাতে পুরো অ্যাপে Riverpod কাজ করতে পারে।
/// ---------------------------------------------------------------------------

void main() async {
  // ১. ফ্ল্যাটার উইজেট বাাইন্ডিং নিশ্চিত করা (অ্যাসিঙ্ক কাজের আগে জরুরি)
  WidgetsFlutterBinding.ensureInitialized();
  
  // ২. এনভায়রনমেন্ট ফাইল (.env) থেকে Gemini API Key লোড করা
  await dotenv.load(fileName: ".env");
  
  // ৩. Riverpod-এর ProviderScope দিয়ে সম্পূর্ণ অ্যাপ্লিকেশনটি র্র্যাপ (wrap) করা
  runApp(
    const ProviderScope(
      child: MyChatApp(),
    ),
  );
}

/// ---------------------------------------------------------------------------
/// 🎨 MY CHAT APP WIDGET (রুট উইজেট)
/// ---------------------------------------------------------------------------
/// ConsumerWidget ব্যবহার করা হয়েছে যাতে Riverpod-এর `themeNotifierProvider` লিসেন করে
/// লাইট থিম (Light Mode) ও ডার্ক থিম (Dark Mode) ডায়নামিকভাবে পরিবর্তন করা যায়।
/// ---------------------------------------------------------------------------
class MyChatApp extends ConsumerWidget {
  const MyChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Riverpod-এর মাধ্যমে বর্তমান থিম মোড (Light/Dark/System) অবজার্ভ করা হচ্ছে
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'AI Topic Assistant',
      debugShowCheckedModeBanner: false,
      
      // ডায়নামিক থিম মোড (Light/Dark Switcher)
      themeMode: themeMode,
      
      // ১. লাইট থিম কনফিগারেশন (Material 3)
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      
      // ২. ডার্ক থিম কনফিগারেশন (Material 3)
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      
      // চ্যাট স্ক্রিন ভিউ (Presentation Layer)
      home: const ChatView(),
    );
  }
}
