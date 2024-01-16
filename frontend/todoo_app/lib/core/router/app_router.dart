import 'package:go_router/go_router.dart';
import 'package:todoo_app/di/di.dart';
import 'package:todoo_app/features/auth/view/login_screen.dart';
import 'package:todoo_app/features/auth/view/register_screen.dart';
import 'package:todoo_app/features/auth/view_model/auth_view_model.dart';

class AppRouter {
  final AuthViewModel viewModel;
  const AppRouter(this.viewModel);

  GoRouter get router => GoRouter(
        initialLocation: LoginForm.route,
        refreshListenable: sl<AuthViewModel>(),
        redirect: (context, state) {
          // if (sl<AuthViewModel>().user == null) {
          //   return LoginForm.route;
          // }

          return null;
        },
        routes: [
          GoRoute(
            path: LoginForm.route,
            builder: (context, state) => const LoginForm(),
          ),
          GoRoute(
            path: RegisterForm.route,
            builder: (context, state) => const RegisterForm(),
          ),
        ],
      );
}
