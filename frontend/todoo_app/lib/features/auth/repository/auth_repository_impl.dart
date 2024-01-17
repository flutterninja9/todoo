import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoo_app/features/auth/endpoint/auth_endpoint.dart';
import 'package:todoo_app/features/auth/model/login_request.dart';
import 'package:todoo_app/features/auth/model/login_response.dart';
import 'package:todoo_app/features/auth/model/register_request.dart';
import 'package:todoo_app/features/auth/model/user_model.dart';
import 'package:todoo_app/features/auth/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthEndpoint _authEndpoint;
  final SharedPreferences _sp;

  AuthRepositoryImpl(this._authEndpoint, this._sp);

  @override
  Future<UserResponse> register(RegisterRequest request) async {
    final result = await _authEndpoint.register(request);
    await _sp.setString("token", result.token);
    return result;
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final result = await _authEndpoint.login(request);
    await _sp.setString("token", result.token);
    return result;
  }
}
