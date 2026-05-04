import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pitboard/features/auth/repo/auth_repository.dart';
import 'package:pitboard/features/auth/viewmodel/auth_viewmodel.dart';

/// Manual fake — extends [AuthRepository] and overrides behaviour
/// without requiring a live Firebase instance.
class _FakeAuthRepo extends AuthRepository {
  bool throwOnSignIn = false;
  final _authState = StreamController<User?>.broadcast();

  @override
  Stream<User?> authStateChanges() => _authState.stream;

  @override
  User? get currentUser => null;

  @override
  Future<UserCredential> signIn(String email, String password) {
    if (throwOnSignIn) throw Exception('sign-in-failed');
    // AuthViewModel ignores the UserCredential return value; auth state
    // is propagated via the stream. Returning a never-completing future
    // simulates a pending network call (used in isLoading assertions).
    return Completer<UserCredential>().future;
  }

  @override
  Future<UserCredential> signUp(String email, String password) =>
      Future.error(UnimplementedError('not tested'));

  @override
  Future<void> signOut() async => _authState.add(null);

  @override
  Future<void> sendPasswordReset(String email) async {}

  void close() => _authState.close();
}

void main() {
  late _FakeAuthRepo repo;
  late AuthViewModel vm;

  setUp(() {
    repo = _FakeAuthRepo();
    vm = AuthViewModel(repository: repo);
  });

  tearDown(() {
    vm.dispose();
    repo.close();
  });

  test('isSignedIn is false when no current user', () {
    expect(vm.isSignedIn, isFalse);
    expect(vm.error, isNull);
    expect(vm.isLoading, isFalse);
  });

  test('signIn sets error and clears isLoading on failure', () async {
    repo.throwOnSignIn = true;
    await vm.signIn('test@example.com', 'wrongpass');

    expect(vm.isLoading, isFalse);
    expect(vm.error, isNotNull);
    expect(vm.error, contains('sign-in-failed'));
  });

  test('error is null before any signIn attempt', () {
    expect(vm.error, isNull);
  });

  test('signOut completes without error', () async {
    await expectLater(vm.signOut(), completes);
    expect(vm.isSignedIn, isFalse);
  });
}
