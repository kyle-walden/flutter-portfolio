import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../repo/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  User? user;
  bool isLoading = false;
  String? error;

  StreamSubscription<User?>? _sub;

  AuthViewModel({AuthRepository? repository}) : _repo = repository ?? AuthRepository() {
    _sub = _repo.authStateChanges().listen((u) {
      user = u;
      notifyListeners();
    });
    user = _repo.currentUser;
  }

  bool get isSignedIn => user != null;

  Future<void> signIn(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _repo.signIn(email, password);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _repo.signUp(email, password);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
