import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showError({
    required String title,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(
          title,
          style: Theme.of(context)
              .snackBarTheme
              .contentTextStyle
              ?.copyWith(color: Colors.redAccent),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
