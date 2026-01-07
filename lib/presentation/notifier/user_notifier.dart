import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/data/models/auth_result.dart';
import '../../features/data/models/user_model.dart';
import '../service/auth_service.dart';

class UserNotifier extends StateNotifier<UserModel> {
  final AuthService _authService;

  UserNotifier(this._authService) : super(UserModel.empty()) {
    _authService.authStateChanges.listen((firebaseUser) {
      if (firebaseUser != null) {
        state = UserModel.fromFirebaseUser(firebaseUser);
      } else {
        state = UserModel.empty();
      }
    });
  }

  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await _authService.signUp(
      name: name,
      email: email,
      password: password,
    );
    return result;
  }

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    final result = await _authService.signIn(
      email: email,
      password: password,
    );
    return result;
  }

  // Misafir olarak devam et
  Future<void> continueAsGuest() async {
    state = UserModel.guest();
  }

  Future<void> logout() async {
    await _authService.signOut();
    state = UserModel.empty();
  }

  Future<AuthResult> resetPassword(String email) async {
    return await _authService.sendPasswordResetEmail(email);
  }
}
