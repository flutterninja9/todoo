import 'package:todoo_app/features/auth/endpoint/auth_endpoint.dart';
import 'package:todoo_app/features/auth/model/login_request.dart';
import 'package:todoo_app/features/auth/model/login_response.dart';
import 'package:todoo_app/features/auth/model/register_request.dart';
import 'package:todoo_app/features/auth/model/user_model.dart';
import 'package:todoo_app/features/auth/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthEndpoint _authEndpoint;

  AuthRepositoryImpl(this._authEndpoint);

  @override
  Future<UserResponse> register(RegisterRequest request) {
    return _authEndpoint.register(request);
  }

  @override
  Future<LoginResponse> login(LoginRequest request) {
    return _authEndpoint.login(request);
  }
}
