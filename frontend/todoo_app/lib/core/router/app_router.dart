import 'package:go_router/go_router.dart';
import 'package:todoo_app/di/di.dart';
import 'package:todoo_app/features/auth/view/auth_view.dart';
import 'package:todoo_app/features/auth/view_model/auth_view_model.dart';
import 'package:todoo_app/features/todo/view/todos_screen.dart';

class AppRouter {
  final AuthViewModel viewModel;
  const AppRouter(this.viewModel);

  GoRouter get router => GoRouter(
        initialLocation: AuthScreen.route,
        refreshListenable: sl<AuthViewModel>(),
        redirect: (context, state) {
          if (sl<AuthViewModel>().token == null) {
            return AuthScreen.route;
          }

          return null;
        },
        routes: [
          GoRoute(
            path: AuthScreen.route,
            builder: (context, state) => const AuthScreen(),
          ),
          GoRoute(
            path: TodosScreen.route,
            builder: (context, state) => const TodosScreen(),
          ),
        ],
      );
}
