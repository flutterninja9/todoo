import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:todoo_app/features/auth/endpoint/auth_endpoint.dart';
import 'package:todoo_app/features/auth/repository/auth_repository.dart';
import 'package:todoo_app/features/auth/repository/auth_repository_impl.dart';
import 'package:todoo_app/features/auth/view_model/auth_view_model.dart';

final sl = GetIt.I;

Future<void> setupServiceContainer() async {
  // core

  // viewmodel
  sl.registerLazySingleton<AuthViewModel>(() => AuthViewModel(sl()));

  // repo
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // endpoint
  sl.registerLazySingleton<AuthEndpoint>(() => AuthEndpoint(sl()));

  // external
  sl.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: "http://localhost:8080")),
  );
}
