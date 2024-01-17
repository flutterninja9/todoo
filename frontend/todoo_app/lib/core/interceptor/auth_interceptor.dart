import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences _sp;

  AuthInterceptor(this._sp);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _sp.getString('token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
