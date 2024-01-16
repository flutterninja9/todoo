import 'package:flutter/material.dart';

class AppTheme extends InheritedWidget {
  final Color textColor;
  final Color orangeColor;
  final Color greenColor;
  final Color backgroundColor;
  final Color iconColor;
  final Color borderColor;
  final Color tileColor;

  const AppTheme({
    super.key,
    required this.textColor,
    required this.orangeColor,
    required this.greenColor,
    required this.backgroundColor,
    required this.iconColor,
    required this.borderColor,
    required this.tileColor,
    required super.child,
  });

  factory AppTheme.dark({required Widget child}) {
    return AppTheme(
      textColor: const Color.fromRGBO(205, 190, 164, 1),
      orangeColor: const Color.fromRGBO(255, 85, 48, 1),
      greenColor: const Color.fromRGBO(87, 202, 75, 1),
      backgroundColor: const Color.fromRGBO(13, 13, 13, 1),
      iconColor: const Color.fromRGBO(205, 190, 164, 1),
      borderColor: const Color.fromRGBO(87, 81, 71, 1),
      tileColor: const Color.fromRGBO(30, 30, 30, 1),
      child: child,
    );
  }

  static AppTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppTheme>();
  }

  static AppTheme of(BuildContext context) {
    final AppTheme? result = maybeOf(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppTheme oldWidget) => true;
}
