import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/services/firebase_service.dart';

/// Small auth repository to wrap FirebaseService for easier testing and replacement.
class AuthRepository {
  Stream<User?> authStateChanges() => FirebaseService.auth.authStateChanges();

  User? get currentUser => FirebaseService.currentUser;

  Future<UserCredential> signIn(String email, String password) =>
      FirebaseService.auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signUp(String email, String password) async {
    final cred = await FirebaseService.auth.createUserWithEmailAndPassword(email: email, password: password);
    try {
      await cred.user?.sendEmailVerification();
    } catch (_) {}
    return cred;
  }

  Future<void> signOut() => FirebaseService.auth.signOut();

  Future<void> sendPasswordReset(String email) => FirebaseService.auth.sendPasswordResetEmail(email: email);
}
