import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:todoo_app/features/auth/model/login_request.dart';
import 'package:todoo_app/features/auth/model/login_response.dart';
import 'package:todoo_app/features/auth/model/register_request.dart';
import 'package:todoo_app/features/auth/model/user_model.dart';

part "auth_endpoint.g.dart";

@RestApi()
abstract class AuthEndpoint {
  factory AuthEndpoint(Dio dio, {String baseUrl}) = _AuthEndpoint;

  @POST('/register')
  Future<UserResponse> register(@Body() RegisterRequest request);

  @POST('/login')
  Future<LoginResponse> login(@Body() LoginRequest request);
}
