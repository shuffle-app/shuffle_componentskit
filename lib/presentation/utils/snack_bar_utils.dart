import 'dart:ui';

import 'package:flutter/material.dart';

class AppSnackBarAction {
  AppSnackBarAction(this.text, {this.withDismiss = true, this.onTap});

  final VoidCallback? onTap;
  final String text;
  final bool withDismiss;
}

class SnackBarUtils {
  SnackBarUtils._();

  static void show({
    required String message,
    Duration? duration,
    required BuildContext context,
    VoidCallback? onTap
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration ?? const Duration(seconds: 3),
        content: Text(message),
        action: SnackBarAction(
          textColor: const Color(0xFFFAF2FB),
          label: 'OK',
          onPressed: onTap ?? (){},
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  static void hideAndShow(
      {required String message, required BuildContext context}) {
    hide(context);
    show(message: message, context: context);
  }
}
