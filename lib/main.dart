import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class MyChatApp extends StatelessWidget {
  const MyChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const ChatView(),
    );
  }
}
