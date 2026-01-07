import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/data/models/user_model.dart';
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
