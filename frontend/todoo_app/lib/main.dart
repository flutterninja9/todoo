import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo_app/core/design_system/app_theme.dart';
import 'package:todoo_app/core/router/app_router.dart';
import 'package:todoo_app/di/di.dart';
import 'package:todoo_app/features/auth/view_model/auth_view_model.dart';

Future<void> main() async {
  await setupServiceContainer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: sl<AuthViewModel>(),
      child: AppTheme.dark(
        child: MaterialApp.router(
          title: 'Todoo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routerConfig: AppRouter(sl<AuthViewModel>()).router,
        ),
      ),
    );
  }
}
