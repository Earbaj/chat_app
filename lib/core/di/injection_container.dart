import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/chat_remote_data_source.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';

/// ---------------------------------------------------------------------------
/// 💉 DEPENDENCY INJECTION (DI) CONTAINER
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// Clean Architecture-এ প্রতিটি লেয়ার একে অপরের ওপর ডিপেন্ডেন্ট না হয়ে কন্ট্যাক্ট বা ইন্টারফেসের ওপর কাজ করে।
/// Riverpod-এর Provider দিয়ে খুব সহজেই Compile-safe Dependency Injection তৈরি করা যায়।
/// 
/// ফ্লো (Flow):
/// Data Source ➔ Repository ➔ Use Case ➔ ViewModel (Presentation)
/// ---------------------------------------------------------------------------

// ১. Remote Data Source Provider (গুগল জেমিনি এপিআই-এর ডাটা সোর্স তৈরি করে)
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSourceImpl();
});

// ২. Repository Provider (Data Source কে ইনজেক্ট করে রিডেবল রিপোজিটরি প্রদান করে)
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final remoteDataSource = ref.watch(chatRemoteDataSourceProvider);
  return ChatRepositoryImpl(remoteDataSource: remoteDataSource);
});

// ৩. Use Case Provider (Repository কে ইনজেক্ট করে বিজনেজ লজিক লেয়ারে প্রোভাইড করে)
final sendChatMessageUseCaseProvider = Provider<SendChatMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SendChatMessageUseCase(repository);
});
