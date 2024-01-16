import 'package:flutter/material.dart';
import 'package:todoo_app/core/async_value/async_value.dart';
import 'package:todoo_app/features/auth/model/login_request.dart';
import 'package:todoo_app/features/auth/model/register_request.dart';
import 'package:todoo_app/features/auth/model/user_model.dart';
import 'package:todoo_app/features/auth/repository/auth_repository.dart';

enum AuthState { initial, loading, loggedIn, loggedOut, error }

class AuthViewModel with ChangeNotifier, StateMixin {
  final AuthRepository _authRepository;

  UserResponse? _user;
  String? _token;

  AuthViewModel(this._authRepository);

  UserResponse? get user => _user;
  String? get token => _token;

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      setLoading();
      final request = RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      final response = await _authRepository.register(request);
      _user = response;
      _token = response.token;
      setState(ViewState.loaded);
    } catch (e) {
      setError('Registration failed: $e');
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      setLoading();
      final request = LoginRequest(
        email: email,
        password: password,
      );
      final response = await _authRepository.login(request);
      _token = response.token;
      setState(ViewState.loaded);
    } catch (e) {
      setError('Login failed: $e');
    }
  }

  Future<void> logoutUser() async {
    setIdle();
    _user = null;
    _token = null;
  }
}
