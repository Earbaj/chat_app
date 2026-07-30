import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/chat_local_data_source.dart';
import '../../data/datasources/chat_remote_data_source.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/get_chat_history_usecase.dart';
import '../../domain/usecases/save_chat_history_usecase.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';

/// ---------------------------------------------------------------------------
/// 💉 DEPENDENCY INJECTION (DI) CONTAINER
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// Clean Architecture-এ প্রতিটি লেয়ার একে অপরের ওপর ডিপেন্ডেন্ট না হয়ে কন্ট্রাক্ট বা ইন্টারফেসের ওপর কাজ করে।
/// Riverpod-এর Provider দিয়ে খুব সহজেই Compile-safe Dependency Injection তৈরি করা যায়।
/// 
/// ফ্লো (Flow):
/// Data Source (Remote & Local) ➔ Repository ➔ Use Cases ➔ ViewModel (Presentation)
/// ---------------------------------------------------------------------------

// ১. Remote Data Source Provider
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSourceImpl();
});

// ২. Local Data Source Provider (SharedPreferences)
final chatLocalDataSourceProvider = Provider<ChatLocalDataSource>((ref) {
  return ChatLocalDataSourceImpl();
});

// ৩. Repository Provider (Injecting Remote & Local Data Sources)
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final remoteDataSource = ref.watch(chatRemoteDataSourceProvider);
  final localDataSource = ref.watch(chatLocalDataSourceProvider);
  return ChatRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// ৪. Use Case Providers
final sendChatMessageUseCaseProvider = Provider<SendChatMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SendChatMessageUseCase(repository);
});

final getChatHistoryUseCaseProvider = Provider<GetChatHistoryUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return GetChatHistoryUseCase(repository);
});

final saveChatHistoryUseCaseProvider = Provider<SaveChatHistoryUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SaveChatHistoryUseCase(repository);
});
