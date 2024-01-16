import 'package:todoo_app/features/auth/model/login_request.dart';
import 'package:todoo_app/features/auth/model/login_response.dart';
import 'package:todoo_app/features/auth/model/register_request.dart';
import 'package:todoo_app/features/auth/model/user_model.dart';

abstract class AuthRepository {
  Future<UserResponse> register(RegisterRequest request);
  Future<LoginResponse> login(LoginRequest request);
}
