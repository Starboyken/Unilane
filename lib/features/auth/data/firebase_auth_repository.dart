import 'package:firebase_auth/firebase_auth.dart';

import 'package:unilane/features/auth/data/auth_repository.dart';
import 'package:unilane/features/auth/domain/auth_user.dart';
import 'package:unilane/features/auth/models/signup_method.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  bool get supportsPhoneAuth => false;

  @override
  AuthUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    return _toAuthUser(user);
  }

  @override
  Future<AuthUser> signIn({
    required String identifier,
    required String password,
  }) async {
    final email = identifier.trim();

    if (!_looksLikeEmail(email)) {
      throw Exception(
        'Phone login is coming soon. Please use your email address for now.',
      );
    }

    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Could not sign you in right now.');
    }

    return _toAuthUser(user);
  }

  @override
  Future<AuthUser> signUp({
    required String displayName,
    required String identifier,
    required String password,
    required SignupMethod signupMethod,
  }) async {
    if (signupMethod == SignupMethod.phone) {
      throw Exception(
        'Phone verification is coming soon. Please use email for now.',
      );
    }

    final email = identifier.trim();
    if (!_looksLikeEmail(email)) {
      throw Exception('Please enter a valid email address.');
    }

    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Could not create your account right now.');
    }

    await user.updateDisplayName(displayName.trim());
    await user.reload();

    final refreshedUser = _firebaseAuth.currentUser ?? user;
    return _toAuthUser(refreshedUser);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  AuthUser _toAuthUser(User user) {
    return AuthUser(
      uid: user.uid,
      displayName:
          user.displayName ?? user.email?.split('@').first ?? 'Student',
      contact: user.email ?? user.phoneNumber ?? '',
      signupMethod: user.email != null
          ? SignupMethod.email
          : SignupMethod.phone,
      isVerifiedStudent: false,
    );
  }

  bool _looksLikeEmail(String value) {
    return value.contains('@');
  }
}
