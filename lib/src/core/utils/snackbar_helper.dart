import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showError(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.red.shade600,
      icon: Icons.error,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.orange.shade700,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.blue.shade600,
      icon: Icons.info,
    );
  }

  static void _showSnackBar(BuildContext context, String message,
      {required Color backgroundColor, required IconData icon}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  // Network Error Shortcut
  static void showNetworkError(BuildContext context) {
    showError(context, 'الرجاء التحقق من اتصال الإنترنت والمحاولة مرة أخرى.');
  }

  // Validation Helper
  static bool validateNotEmpty(
      {required BuildContext context,
      required dynamic value,
      required String fieldName}) {
    if (value == null ||
        (value is String && value.trim().isEmpty) ||
        (value is List && value.isEmpty) ||
        (value is Map && value.isEmpty)) {
      showWarning(context, 'حقل "$fieldName" لا يمكن أن يكون فارغًا');
      return false;
    }
    return true;
  }
}
