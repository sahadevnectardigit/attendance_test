import 'package:attendance/main.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showSnackBar(
    String message, {
    Color color = Colors.black87,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
  }) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    final snackBar = SnackBar(
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      content: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.white),
          if (icon != null) const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void success(String message) {
    showSnackBar(message, color: Colors.green, icon: Icons.check_circle);
  }

  static void error(String message) {
    showSnackBar(message, color: Colors.red, icon: Icons.error);
  }

  static void info(String message) {
    showSnackBar(message, color: Colors.blue, icon: Icons.info);
  }
}
// 