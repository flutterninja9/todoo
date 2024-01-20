import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoo_app/core/interceptor/auth_interceptor.dart';
import 'package:todoo_app/core/router/app_router.dart';
import 'package:todoo_app/features/auth/endpoint/auth_endpoint.dart';
import 'package:todoo_app/features/auth/repository/auth_repository.dart';
import 'package:todoo_app/features/auth/repository/auth_repository_impl.dart';
import 'package:todoo_app/features/auth/view_model/auth_view_model.dart';
import 'package:todoo_app/features/todo/endpoint/todos_endpoint.dart';
import 'package:todoo_app/features/todo/repository/todos_repository.dart';
import 'package:todoo_app/features/todo/repository/todos_repository_impl.dart';
import 'package:todoo_app/features/todo/view_model/create_todo_view_model.dart';
import 'package:todoo_app/features/todo/view_model/edit_todo_viewmodel.dart';
import 'package:todoo_app/features/todo/view_model/todos_view_model.dart';

final sl = GetIt.I;

Future<void> setupServiceContainer() async {
  // core
  sl.registerLazySingleton<AppRouter>(() => AppRouter(sl()));

  // viewmodel
  sl.registerFactory<CreateTodoViewModel>(() => CreateTodoViewModel());
  sl.registerFactory<EditTodoViewModel>(() => EditTodoViewModel());
  sl.registerLazySingleton<AuthViewModel>(() => AuthViewModel(sl()));
  sl.registerFactory<TodoViewModel>(() => TodoViewModel(sl()));

  // repo
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<TodosRepository>(() => TodosRepositoryImpl(sl()));

  // endpoint
  sl.registerLazySingleton<AuthEndpoint>(() => AuthEndpoint(sl()));
  sl.registerLazySingleton<TodosEndpoint>(() => TodosEndpoint(sl()));

  // external
  final sp = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sp);
  sl.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: "http://localhost:8080")),
  );
  sl<Dio>().interceptors.add(AuthInterceptor(sl()));
}
