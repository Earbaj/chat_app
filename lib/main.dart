import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/theme_provider.dart';
import 'presentation/views/chat_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables (.env)
  await dotenv.load(fileName: ".env");
  
  runApp(
    const ProviderScope(
      child: MyChatApp(),
    ),
  );
}

class MyChatApp extends ConsumerWidget {

  const MyChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'AI Chat Assistant',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const ChatView(),
    );
  }
}

