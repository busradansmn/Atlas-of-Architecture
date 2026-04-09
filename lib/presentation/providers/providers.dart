import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/data/models/chat_message.dart';
import '../../features/data/models/user_model.dart';
import '../notifier/chat_notifier.dart';
import '../notifier/user_notifier.dart';
import '../service/auth_service.dart';

//Auth Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// User Provider
final userProvider = StateNotifierProvider<UserNotifier, UserModel>((ref) {
  final authService = ref.watch(authServiceProvider);
  return UserNotifier(authService);
});

// Bottom Navigation Provider
final bottomNavProvider = StateProvider<int>((ref) => 0);

// Chat Provider
final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier();
});