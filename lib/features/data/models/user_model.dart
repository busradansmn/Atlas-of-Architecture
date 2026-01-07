import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final bool isGuest;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.isGuest = false,
  });

  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      uid: user.uid,
      name: user.displayName,
      email: user.email,
      isGuest: false,
    );
  }

  factory UserModel.guest() {
    return UserModel(
      uid: null,
      name: 'Misafir',
      email: null,
      isGuest: true,
    );
  }

  // Boş kullanıcı (çıkış yapmış)
  factory UserModel.empty() {
    return UserModel(
      uid: null,
      name: null,
      email: null,
      isGuest: false,
    );
  }

  bool get isAuthenticated => uid != null && !isGuest;
}
