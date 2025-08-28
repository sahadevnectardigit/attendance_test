import 'package:flutter/material.dart';

extension SnackBarExtension on BuildContext {
  void showSnackBarMessage({
    required String message,
    Color? backgroundColor,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Colors.black87,
        behavior: behavior,
        duration: duration,
      ),
    );
  }
}
