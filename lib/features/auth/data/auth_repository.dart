import 'package:unilane/features/auth/domain/auth_user.dart';
import 'package:unilane/features/auth/models/signup_method.dart';

abstract class AuthRepository {
  bool get supportsPhoneAuth;
  AuthUser? get currentUser;

  Future<AuthUser> signIn({
    required String identifier,
    required String password,
  });

  Future<AuthUser> signUp({
    required String displayName,
    required String identifier,
    required String password,
    required SignupMethod signupMethod,
  });

  Future<void> signOut();
}
