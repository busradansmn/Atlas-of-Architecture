import 'package:firebase_auth/firebase_auth.dart';
import '../../features/data/models/auth_result.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if (password.length < 6) {
        return AuthResult(
          success: false,
          message: 'Şifre en az 6 karakter olmalıdır',
        );
      }
      if (!email.contains('@')) {
        return AuthResult(
          success: false,
          message: 'Geçerli bir e-posta adresi girin',
        );
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      return AuthResult(
        success: true,
        message: 'Kayıt başarılı!',
        user: _auth.currentUser,
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Bu e-posta adresi zaten kullanımda';
          break;
        case 'invalid-email':
          message = 'Geçersiz e-posta adresi';
          break;
        case 'operation-not-allowed':
          message = 'E-posta/şifre girişi etkin değil';
          break;
        case 'weak-password':
          message = 'Şifre çok zayıf';
          break;
        default:
          message = 'Kayıt sırasında bir hata oluştu: ${e.message}';
      }
      return AuthResult(success: false, message: message);
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Beklenmeyen bir hata oluştu: $e',
      );
    }
  }

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (password.length < 6) {
        return AuthResult(
          success: false,
          message: 'Şifre en az 6 karakter olmalıdır',
        );
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return AuthResult(
        success: true,
        message: 'Giriş başarılı!',
        user: userCredential.user,
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Bu e-posta ile kayıtlı kullanıcı bulunamadı';
          break;
        case 'wrong-password':
          message = 'Yanlış şifre';
          break;
        case 'invalid-email':
          message = 'Geçersiz e-posta adresi';
          break;
        case 'user-disabled':
          message = 'Bu hesap devre dışı bırakılmış';
          break;
        case 'invalid-credential':
          message = 'E-posta veya şifre hatalı';
          break;
        default:
          message = 'Giriş sırasında bir hata oluştu: ${e.message}';
      }
      return AuthResult(success: false, message: message);
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Beklenmeyen bir hata oluştu: $e',
      );
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult(
        success: true,
        message: 'Şifre sıfırlama e-postası gönderildi',
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Bu e-posta ile kayıtlı kullanıcı bulunamadı';
          break;
        case 'invalid-email':
          message = 'Geçersiz e-posta adresi';
          break;
        default:
          message = 'Bir hata oluştu: ${e.message}';
      }
      return AuthResult(success: false, message: message);
    }
  }
}
