import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  // ----------------------------------------------------
  // PREVIOUS (Non-Streaming): পুরো উত্তর না আসা পর্যন্ত অপেক্ষা করে
  // ----------------------------------------------------
  // Future<ChatMessageModel> sendTopicPrompt(String topic);

  // ----------------------------------------------------
  // NEW (Streaming): ChatGPT-এর মতো রিয়েল-টাইমে চাংক (chunk) আকারে স্ট্রিম করে
  // ----------------------------------------------------
  Stream<String> sendTopicPromptStream(String topic);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final String _apiKey;

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
  // NEW STREAMING IMPLEMENTATION
  // ----------------------------------------------------
  @override
  Stream<String> sendTopicPromptStream(String topic) async* {
    if (_apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not configured in .env file');
    }

    final provider = GoogleProvider(apiKey: _apiKey);
    final agent = Agent.forProvider(
      provider,
      chatModelName: 'gemini-3-flash-preview',
    );

    // agent.sendStream-এর মাধ্যমে রিয়েল-টাইমে স্ট্রিম রেসপন্স পাওয়া যায়
    final responseStream = agent.sendStream('Give me details about $topic');
    
    await for (final chunk in responseStream) {
      yield chunk.output;
    }
  }
}
