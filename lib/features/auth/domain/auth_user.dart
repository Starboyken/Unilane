import 'package:unilane/features/auth/models/signup_method.dart';

class AuthUser {
  const AuthUser({
    required this.uid,
    required this.displayName,
    required this.contact,
    required this.signupMethod,
    this.isVerifiedStudent = false,
  });

  final String uid;
  final String displayName;
  final String contact;
  final SignupMethod signupMethod;
  final bool isVerifiedStudent;
}
