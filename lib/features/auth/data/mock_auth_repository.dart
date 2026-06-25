import 'dart:async';

import 'package:unilane/features/auth/data/auth_repository.dart';
import 'package:unilane/features/auth/domain/auth_user.dart';
import 'package:unilane/features/auth/models/signup_method.dart';

class MockAuthRepository implements AuthRepository {
  int _nextUserId = 1;
  AuthUser? _currentUser;

  @override
  bool get supportsPhoneAuth => true;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Future<AuthUser> signIn({
    required String identifier,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final user = AuthUser(
      uid: 'user_${_nextUserId++}',
      displayName: _buildDisplayName(identifier),
      contact: identifier.trim(),
      signupMethod: _looksLikeEmail(identifier)
          ? SignupMethod.email
          : SignupMethod.phone,
      isVerifiedStudent: true,
    );

    _currentUser = user;
    return user;
  }

  @override
  Future<AuthUser> signUp({
    required String displayName,
    required String identifier,
    required String password,
    required SignupMethod signupMethod,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final user = AuthUser(
      uid: 'user_${_nextUserId++}',
      displayName: displayName.trim(),
      contact: identifier.trim(),
      signupMethod: signupMethod,
      isVerifiedStudent: true,
    );

    _currentUser = user;
    return user;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  String _buildDisplayName(String identifier) {
    final cleaned = identifier.trim();

    if (cleaned.isEmpty) {
      return 'UniLane Student';
    }

    if (_looksLikeEmail(cleaned)) {
      return cleaned.split('@').first;
    }

    return cleaned.startsWith('+') ? cleaned : cleaned;
  }

  bool _looksLikeEmail(String value) {
    return value.contains('@');
  }
}
