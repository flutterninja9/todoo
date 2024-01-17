import 'package:flutter/material.dart';
import 'package:todoo_app/features/auth/view/login_screen.dart';
import 'package:todoo_app/features/auth/view/register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const route = "/authenticate";
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginMode = true;

  @override
  Widget build(BuildContext context) {
    if (isLoginMode) {
      return LoginForm(
        onClickRegister: () {
          setState(() {
            isLoginMode = false;
          });
        },
      );
    }
    return RegisterForm(
      onClickLogin: () {
        setState(() {
          isLoginMode = true;
        });
      },
    );
  }
}
