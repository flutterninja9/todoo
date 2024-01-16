import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todoo_app/core/async_value/async_value.dart';
import 'package:todoo_app/core/design_system/app_theme.dart';
import 'package:todoo_app/features/auth/view/login_screen.dart';
import 'package:todoo_app/features/auth/view_model/auth_view_model.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);
  static const route = "/register";

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
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
          'Register',
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
                    controller: firstNameController,
                    style: TextStyle(color: AppTheme.of(context).textColor),
                    decoration: InputDecoration(
                      labelText: 'First Name',
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
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: lastNameController,
                    style: TextStyle(color: AppTheme.of(context).textColor),
                    decoration: InputDecoration(
                      labelText: 'Last Name',
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
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: emailController,
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
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          provider.registerUser(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppTheme.of(context).backgroundColor,
                        backgroundColor: AppTheme.of(context).orangeColor,
                      ),
                      child: const Text('Register'),
                    );
                  }),
                  const SizedBox(height: 24.0),
                  TextButton(
                    onPressed: () => context.go(LoginForm.route),
                    style: TextButton.styleFrom(
                        foregroundColor: AppTheme.of(context).textColor),
                    child: const Text('Already have an account? Sign-in'),
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
