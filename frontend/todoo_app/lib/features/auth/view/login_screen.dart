import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todoo_app/core/async_value/async_value.dart';
import 'package:todoo_app/core/design_system/app_theme.dart';
import 'package:todoo_app/features/auth/view_model/auth_view_model.dart';
import 'package:todoo_app/features/todo/view/todos_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, required this.onClickRegister}) : super(key: key);
  final VoidCallback onClickRegister;
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: "test@gmail.com");
    passwordController = TextEditingController(text: "test123");
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.of(context).backgroundColor,
        elevation: 0, // Remove app bar shadow
        title: Text(
          'Login',
          style: TextStyle(color: AppTheme.of(context).textColor),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppTheme.of(context).backgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 512),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    cursorColor: AppTheme.of(context).orangeColor,
                    style: TextStyle(color: AppTheme.of(context).textColor),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle:
                          TextStyle(color: AppTheme.of(context).textColor),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.of(context).borderColor),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.of(context).borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.of(context).borderColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: passwordController,
                    style: TextStyle(color: AppTheme.of(context).textColor),
                    cursorColor: AppTheme.of(context).orangeColor,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle:
                          TextStyle(color: AppTheme.of(context).textColor),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.of(context).borderColor),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.of(context).borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.of(context).borderColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  Consumer<AuthViewModel>(builder: (context, provider, child) {
                    if (provider.state == ViewState.loading) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: AppTheme.of(context).orangeColor,
                      ));
                    }

                    return ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          provider.loginUser(
                            email: emailController.text,
                            password: passwordController.text,
                            postSuccessCallback: () {
                              context.go(TodosScreen.route);
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppTheme.of(context).backgroundColor,
                        backgroundColor: AppTheme.of(context).orangeColor,
                      ),
                      child: const Text('Login'),
                    );
                  }),
                  const SizedBox(height: 24.0),
                  TextButton(
                    onPressed: widget.onClickRegister,
                    style: TextButton.styleFrom(
                        foregroundColor: AppTheme.of(context).textColor),
                    child: const Text('Don\t have an account? Create one now'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
