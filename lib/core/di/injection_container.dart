import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/chat_remote_data_source.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';

// 1. Data Source Provider
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSourceImpl();
});

// 2. Repository Provider (Injecting Data Source)
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final remoteDataSource = ref.watch(chatRemoteDataSourceProvider);
  return ChatRepositoryImpl(remoteDataSource: remoteDataSource);
});

// 3. Use Case Provider (Injecting Repository)
final sendChatMessageUseCaseProvider = Provider<SendChatMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SendChatMessageUseCase(repository);
});
