import 'package:firebase_auth/firebase_auth.dart';

/// Handles admin login/logout. There's no public sign-up screen — admin
/// accounts are created manually from the Firebase Console
/// (Authentication → Users → Add user).
class AuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // null = success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';
        case 'invalid-email':
          return 'That email address looks invalid.';
        default:
          return 'Login failed: ${e.message}';
      }
    }
  }

  Future<void> signOut() => _auth.signOut();
}
