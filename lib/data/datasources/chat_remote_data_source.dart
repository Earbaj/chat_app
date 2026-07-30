import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/chat_message_model.dart';

/// ---------------------------------------------------------------------------
/// 🌐 DATA SOURCE: ChatRemoteDataSource (রিমোট ডেটা সোর্স)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// Data Source লেয়ার মূলত সরাসরি থার্ডপার্টি সার্ভিস (যেমন: Google Gemini API)
/// বা লোকাল ডাটাবেজের সাথে যোগাযোগ পরিচালনা করে।
/// ---------------------------------------------------------------------------

abstract class ChatRemoteDataSource {
  /*
  // ----------------------------------------------------
  // PREVIOUS (Non-Streaming): পুরো উত্তর না আসা পর্যন্ত অপেক্ষা করে
  // (শিক্ষার জন্য কমেন্ট করে রাখা হলো)
  // ----------------------------------------------------
  Future<ChatMessageModel> sendTopicPrompt(String topic);
  */

  // ----------------------------------------------------
  // NEW (Streaming): ChatGPT-এর মতো রিয়েল-টাইমে চাংক (chunk) আকারে স্ট্রিম করে
  // ----------------------------------------------------
  Stream<String> sendTopicPromptStream(String topic);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final String _apiKey;

  // .env ফাইল থেকে সরাসরি API Key রিড করে
  ChatRemoteDataSourceImpl({String? apiKey})
      : _apiKey = apiKey ?? dotenv.env['GEMINI_API_KEY'] ?? '';

  /*
  // ----------------------------------------------------
  // PREVIOUS NON-STREAMING IMPLEMENTATION (শিক্ষার জন্য কমেন্ট করা হলো)
  // ----------------------------------------------------
  @override
  Future<ChatMessageModel> sendTopicPrompt(String topic) async {
    if (_apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not configured in .env file');
    }

    final provider = GoogleProvider(apiKey: _apiKey);
    final agent = Agent.forProvider(
      provider,
      chatModelName: 'gemini-3-flash-preview',
    );

    final response = await agent.send('Give me details about $topic');
    final String responseId = DateTime.now().millisecondsSinceEpoch.toString();

    return ChatMessageModel.fromAiResponse(response.output, responseId);
  }
  */

  // ----------------------------------------------------
  // NEW STREAMING IMPLEMENTATION (Google Gemini Streaming Response)
  // ----------------------------------------------------
  @override
  Stream<String> sendTopicPromptStream(String topic) async* {
    if (_apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not configured in .env file');
    }

    // ১. Google Provider তৈরি করা (API Key প্রদান করে)
    final provider = GoogleProvider(apiKey: _apiKey);
    
    // ২. dartantic_ai এর Agent ক্লাস দিয়ে Gemini 3 Flash প্রেভিউ মডেল কনফিগার করা
    final agent = Agent.forProvider(
      provider,
      chatModelName: 'gemini-3-flash-preview',
    );

    // ৩. agent.sendStream()-এর মাধ্যমে রিয়েল-টাইমে স্ট্রিম রেসপন্স লিসেন করা
    final responseStream = agent.sendStream('Give me details about $topic');
    
    // ৪. `async*` এবং `yield` ব্যবহার করে প্রতিবার নতুন শব্দ আসলে পাঠানো (Streaming)
    await for (final chunk in responseStream) {
      yield chunk.output;
    }
  }
}
