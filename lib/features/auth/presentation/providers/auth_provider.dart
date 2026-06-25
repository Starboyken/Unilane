import 'package:flutter/foundation.dart';

import 'package:unilane/features/auth/data/auth_repository.dart';
import 'package:unilane/features/auth/domain/auth_user.dart';
import 'package:unilane/features/auth/models/signup_method.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthRepository repository}) : _repository = repository;

  final AuthRepository _repository;

  SignupMethod _signupMethod = SignupMethod.email;
  bool _isBusy = false;
  String? _errorMessage;
  AuthUser? _currentUser;

  SignupMethod get signupMethod => _signupMethod;
  bool get supportsPhoneAuth => _repository.supportsPhoneAuth;
  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;
  AuthUser? get currentUser => _currentUser ?? _repository.currentUser;

  void setSignupMethod(SignupMethod method) {
    if (_signupMethod == method) return;

    _signupMethod = method;
    notifyListeners();
  }

  Future<AuthUser?> signIn({
    required String identifier,
    required String password,
  }) async {
    _setBusy(true);

    try {
      final user = await _repository.signIn(
        identifier: identifier,
        password: password,
      );
      _currentUser = user;
      _errorMessage = null;
      return user;
    } catch (error) {
      _errorMessage = _friendlyMessage(error);
      return null;
    } finally {
      _setBusy(false);
    }
  }

  Future<AuthUser?> signUp({
    required String displayName,
    required String identifier,
    required String password,
  }) async {
    _setBusy(true);

    try {
      final user = await _repository.signUp(
        displayName: displayName,
        identifier: identifier,
        password: password,
        signupMethod: _signupMethod,
      );
      _currentUser = user;
      _errorMessage = null;
      return user;
    } catch (error) {
      _errorMessage = _friendlyMessage(error);
      return null;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  void _setBusy(bool value) {
    if (_isBusy == value) return;

    _isBusy = value;
    notifyListeners();
  }

  String _friendlyMessage(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
