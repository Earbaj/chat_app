import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatMessageModel> sendTopicPrompt(String topic);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final String _apiKey;

  ChatRemoteDataSourceImpl({String? apiKey})
      : _apiKey = apiKey ?? dotenv.env['GEMINI_API_KEY'] ?? '';

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
}
